class DebatesController < ApplicationController

  require 'opentok'
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
  before_filter :config_opentok, :except => [:index, :destroy]
  before_filter :find_user, :except => [:create, :new]

  def index
    @debates = Debate.find(params[:user_id])
  end

  def new
    @user = User.find(params[:user_id])
    @debate = Debate.new
    @categories = Category.all
    @debate_styles = DebateStyles.all

    @debate.debater_invites.build
    @debate.moderator_invites.build
    # Adjust number of @debater_invites based on debate style
    if session[:user_id].nil?
      flash[:success] = false
      flash[:message] = "Failed to create Debate!"
      redirect_to new_debate_path
    end
  end

  def create
    @user = User.find(params[:user_id])
    @debate = @user.debates.build(debate_params)

    # maybe helper method?
    @debate.moderator_invites.each do |moderator_invite|
      @user = User.find_by(:email => moderator_invite.user_name)
      if @user.nil?
        flash[:success] = false
        flash[:message] = "Failed to create Debate! Unknown user: #{moderator_invite.user_name}"
        redirect_to new_user_debate_path and return
      else
        moderator_invite.user_id = @user.id
      end
    end

    @debate.debater_invites.each do |debater_invite|
      @user = User.find_by(:email => debater_invite.user_name)
      if @user.nil?
        flash[:success] = false
        flash[:message] = "Failed to create Debate! Unknown user: #{debater_invite.user_name}"
        redirect_to new_user_debate_path and return
      else
        debater_invite.user_id = @user.id
      end
    end

    if @debate.save
      # if we're the owner, go ahead and generate token now
      flash[:success] = true
      flash[:message] = "Successfully created new debate!"
      respond_to do |format|
        format.html {redirect_to user_debate_path(:id => @debate.id)}
        format.js
      end
    else
      flash[:success] = false
      flash[:message] = "Failed to create Debate!"
      redirect_to new_debate_path
    end
  end

  def show
    # render but don't connect current user
    @debate = Debate.find(params[:id])

    @debater_invite = @debate.debater_invites[0]
    @moderator_invite = @debate.moderator_invites[0]

    @debater = session[:user_id] == @debater_invite.user_id
    @owner = session[:user_id] == @debate.user_id
    @moderator = session[:user_id] == @moderator_invite.user_id

    if session[:user_id]
      #subscriber role for onlookers!
      if (@owner || @debater)
        if @owner
          @tok_token = @opentok.generate_token(@debate.tok_session_id, :role => :publisher, :data => "owner")
        else
          @tok_token = @opentok.generate_token(@debate.tok_session_id, :role => :publisher, :data => "debater")
        end
      elsif @moderator_invite
        @moderator = true
        @tok_token = @opentok.generate_token(@debate.tok_session_id, :role => :moderator, :data => "moderator")
      else
        @publisher = false
        @tok_token = @opentok.generate_token(@debate.tok_session_id, :role => :subscriber)
      end
      # flash[:success] = true
      # flash[:message] = "Connected to Debate! Make sure to enable your microphone"
      render 'one_versus_one'
    else
      flash[:success] = false
      flash[:message] = "You must be signed in to use this feature!"
      redirect_to login_path
    end
  end

  def join
    # accept invitation, create new debate_user, and
    # redirect to the debate show path (not as a spectator)
    @debate = Debate.find(params[:id])
  end

  def destroy
  end

  private
  def config_opentok
    if @opentok.nil?
      @opentok = OpenTok::OpenTok.new '45241592', 'b099560439c52ed195d79cb7c15fbae1d9b33f1e'
    end
  end

  def debate_params
    params.require(:debate).permit(:category_id, :debate_style_id, :topic, :name, :description, :public, :size,
                                   :debater_invites_attributes => [:user_name, :invite_message],
                                   :moderator_invites_attributes => [:user_name, :invite_message])
  end

  def find_user
    @user = User.find(session[:user_id])
  end
end
