class FiretalksController < ApplicationController

  require 'opentok'
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
  before_filter :config_opentok, :except => [:index, :destroy]

  def new
    @user = User.find(params[:user_id])
    @firetalk = Firetalk.new
    @firetalk_user = FiretalkDebater.new
  end

  def create
    @user = User.find(params[:user_id])
    @firetalk = Firetalk.new(firetalk_params)
    if @firetalk.save
      flash[:success] = true
      flash[:message] = "Successfully created new Firetalk!"
      redirect_to user_firetalk_path(:id => @firetalk.id)
    else
      flash[:success] = false
      flash[:message] = "Failed to create Firetalk"
      redirect_to new_user_firetalk_path
    end
  end

  def show
    @firetalk = Firetalk.find(params[:id])
    # NOT YET if @firetalk.public
    @user = User.find(session[:user_id])
    @firetalk.firetalk_debaters.each do |firetalk_debater|
      if firetalk_debater.email == @user.email
      # Some fancy js shit, maybe just generate publisher role...
        @tok_token = @opentok.generate_token(@firetalk.tok_session_id, :role => :publisher, :data => @user.email)
      end
    end
    @tok_token = @opentok.generate_token(@firetalk.tok_session_id, :role => :subscriber, :data => @user.id)
  end

  def join
  end

  private
  def firetalk_params
    params.require(:firetalk).permit(:topic, :name, :description, :rounds, :seconds,
                                      :firetalk_debaters_attributes => [:email])
  end

  def config_opentok
    if @opentok.nil?
      @opentok = OpenTok::OpenTok.new '45241592', 'b099560439c52ed195d79cb7c15fbae1d9b33f1e'
    end
  end
end
