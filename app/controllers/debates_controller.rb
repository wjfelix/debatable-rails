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
  end

  def create
    @user = User.find(params[:user_id])
    @debate = @user.debates.build(debate_params)
    if @debate.save
      # @new_debate.debate_users.create
      # Hold off on creating debate_users, not sure yet if we need it
      flash[:success] = true
      flash[:message] = "Successfully created new debate!"
      redirect_to user_debate_path(:id => @debate.id)
    else
      flash[:success] = false
      flash[:message] = "Failed to create Debate!"
      redirect_to new_debate_path
    end
  end

  def show
    config_opentok
    # Only allow to join if we are currently logged in
    @debate = Debate.find(params[:id])
    #@debate_user = @debate.debate_users.where(:)
    if session[:user_id]
      #Find DebateUser object here


      #Generate token type based on debate user
      @tok_token = @opentok.generate_token(@debate.tok_session_id)
      flash[:success] = true
      flash[:message] = "Connected to Debate! Make sure to enable your microphone"
      #Redirect to the appropriate paths per debate style
      # QnA
      if @debate.debate_style == 1
        render 'question_answer'
      elsif @debate.debate_style == 2
        render 'one_versus_one'
      elsif @debate.debate_style == 3
        render 'two_versus_two'
      elsif @debate.debate_style == 4
        render 'three_versus_three'
      elsif @debate.debate_style == 5
        render 'four_versus_four'
      elsif @debate.debate_style == 6
        render 'firetalk'
      elsif
        render 'discussion_freetalk'
      end
    else
      flash[:success] = false
      flash[:message] = "You must be signed in to use this feature!"
      redirect_to login_path
    end
  end

  def invite
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
    params.require(:debate).permit(:category_id, :debate_style_id, :topic, :name, :description, :public)
  end

  def find_user
    @user = User.find(session[:user_id])
  end
end
