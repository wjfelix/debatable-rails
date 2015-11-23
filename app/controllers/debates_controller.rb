class DebatesController < ApplicationController

  require 'opentok'
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
  before_filter :config_opentok, :except => [:index, :destroy]

  def index
    @debates = Debate.find(params[:user_id])
  end

  def new
    @debate = Debate.new
  end

  def create
    config_opentok

    @debate = Debate.new(debate_params)
    @user = User.find(session[:user_id])
    if @debate.save
      # @new_debate.debate_users.create
      # Hold off on creating debate_users, not sure yet if we need it
      flash[:success] = true
      flash[:message] = "Successfully created new debate!"
      @tok_token = @opentok.generate_token(@debate.tok_session_id)
      redirect_to user_debate_path(:id => @debate.id)
    else
      flash[:success] = false
      flash[:message] = "Failed to create Debate!"
      redirect_to new_debate_path
    end
  end

  def join
    render 'show'
  end

  def show
    # Only allow to join if we are currently logged in
    if session[:user_id]
      @user = User.find(session[:user_id])
    end

    @debate = Debate.find(params[:id])
    # @tok_token = @opentok.generate_token(@debate.tok_session_id).to_s
    @debate_users = @debate.debate_users
  end

  def invite
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
