class DebatesController < ApplicationController

  require 'opentok'
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
  before_filter :config_opentok, :except => [:index, :destroy]

  def index
    @debates = Debate.find(params[:user_id])
  end

  def new
    @user = User.find(params[:user_id])
    @debate = Debate.new
  end

  def create
    config_opentok

    session = @opentok.create_session
    params[:debate][:tok_session_id] = session.session_id

    @new_debate = Debate.new(debate_params)
    @new_debate.tok_session_id = params[:debate][:tok_session_id]

    if @new_debate.save
      flash[:success] = true
      flash[:message] = "Successfully created new debate!"
      # redirect_to user_debate_path(:id => @new_debate.id)
      self.join
    else
      flash[:success] = false
      flash[:message] = "Failed to create Debate!"
      redirect_to new_debate_path
    end
  end

  def show
    @debate = Debate.find(params[:id])
    # @tok_token = @opentok.generate_token(@debate.tok_session_id).to_s
    @debate_users = Debate.debate_users
  end

  def invite
  end

  def join
    @user = User.find(session[:user_id])
    # @debate = Debate.find(params[:id])
    # @debate_invite = DebateInvites.find(:invite_email => @user.email)

    if @user 
      @debate_user = DebateUser.new
      if @new_debate && @user.id == @new_debate.user_id
        # If the user created a new debate, Generate a new
        # OpenTok session and DebateUser (The owner) and then
        # redirect to the showpath of the debate

        @tok_token = @opentok.generate_token(@new_debate.tok_session_id).to_s
        render 'new_debate'
      else
        # If the user did NOT create the debate, create a new
        # DebateUser and join the existing OpenTok session
        # By generating a token through javascript

        flash[:success] = true
        flash[:message] = "Successfully joined debate!"
        render 'join'
        # redirect_to debates_show_path(@debate)
      end
    end
  end

  def destroy
  end

  private
  def get_sessions
    @debate_users = @debate.debate_users
    # var session = TB.initSession(@debate.tok_session_id)

  end

  def config_opentok
    if @opentok.nil?
      @opentok = OpenTok::OpenTok.new '45241592', 'b099560439c52ed195d79cb7c15fbae1d9b33f1e'
    end
  end

  def debate_params
    params.require(:debate).permit(:category, :topic, :name, :description, :debate_style, :public)
  end
end
