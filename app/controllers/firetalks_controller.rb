class FiretalksController < ApplicationController

  require 'opentok'
  require 'json'
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
  before_filter :config_opentok, :except => [:index, :destroy]
  before_filter :is_logged_in
  #before_filter :store_route

  def new
    if (session[:user_id].to_s == params[:user_id].to_s)
      @user = User.find(params[:user_id])
      @firetalk = Firetalk.new
      @firetalk.firetalk_debaters.build
    else
      @user = User.find(session[:user_id])
      redirect_to new_user_firetalk_path(@user)
    end
  end

  def create
    @user = User.find(params[:user_id])
    @firetalk = Firetalk.new(firetalk_params)

    #adding ourselves (owner)
    @owner = @firetalk.firetalk_debaters.build(:firetalk_id => @firetalk.id, :email => @user.email, :user_id => @user.id)
    user_ids = params[:firetalk][:user_tokens].split(",")

    @users_to_invite = []

    user_ids.each do |user_id|
      user = User.find(user_id) if user_id && user_id != ""
      if user
        @firetalk.firetalk_debaters.build(:firetalk_id => @firetalk.id, :email => user.email, :user_id => user_id)
        # add a new debater_invite to the user
        @users_to_invite.push(User.find(user_id));
      else
        flash[:message] = "Failed to create Firetalk"
        redirect_to new_user_firetalk_path
      end
    end

    if @firetalk.save!(firetalk_params)
      flash[:success] = true
      flash[:message] = "Successfully created new Firetalk!"

      @firetalk.firetalk_debaters.each do |firetalk_debater|
        UserMailer.send_firetalk_invite(@firetalk, firetalk_debater).deliver
      end

      @users_to_invite.each do |user|
        invite = user.invites.build(:email => user.email, :from => @user.email,
                          :message => "#{@user.firstname} has challeneged you to a firetalk!",
                          :path => user_firetalk_path(:id => @firetalk.id, :user_id => @user.id))
        invite.save!
      end

      redirect_to user_firetalk_path(:id => @firetalk.id)
    else
      flash[:message] = "Failed to create Firetalk"
      redirect_to new_user_firetalk_path
    end
  end

  def show
    @firetalk = Firetalk.find(params[:id])
    @firetalk_debaters = @firetalk.firetalk_debaters

    @users = []

    @user = User.find(session[:user_id])
    @my_firetalk_debater = FiretalkDebater.where(:user_id => @user.id, :firetalk_id => @firetalk.id)
    @is_debater = false;
    @is_owner = @firetalk.user_id == session[:user_id]
    if (session[:user_id] == @user.id)
      @is_debater = true;
    else
      @firetalk_debaters.each do |debater|
        if (session[:user_id] == debater.user_id)
          @is_debater = true
        end
      end
    end

    respond_to do |format|
      # Hash to map debater email to ID so we can convert
      # to json and properly bind points to debaters in show view
      firetalk_debaters_hash = {}
      index = 0
      @firetalk_debaters.each do |firetalk_debater|
        firetalk_debaters_hash[firetalk_debater.email] = index
        @users[index] = User.find_by_email(firetalk_debater.email)
        index = index + 1
      end
      @firetalk_json = firetalk_debaters_hash.to_json

      # If owner
      if @firetalk.user_id == @user.id
        @tok_token = @opentok.generate_token(@firetalk.tok_session_id, :role => :moderator, :data => "0|#{@user.email}")
      # If invited
      elsif is_invited(@user.email)
        @tok_token = @opentok.generate_token(@firetalk.tok_session_id, :role => :publisher, :data => "0|#{@user.email}")
      # If voter
      else
        @tok_token = @opentok.generate_token(@firetalk.tok_session_id, :role => :subscriber)
      end
      format.html
      format.json { render json: @my_firetalk_debater }
    end
  end

  def join
  end

  private
  def firetalk_params
    params.require(:firetalk).permit(:topic, :name, :description, :user_id, :user_tokens)
  end

  def config_opentok
    if @opentok.nil?
      @opentok = OpenTok::OpenTok.new '45241592', 'b099560439c52ed195d79cb7c15fbae1d9b33f1e'
    end
  end

  def is_invited(email)
    @firetalk_debaters.each do |firetalk_debater|
      if firetalk_debater.email == email
        return true
      end
    end
    return false
  end

  def is_logged_in
    if (session[:user_id].nil?)
      flash[:message] = true
      flash[:message] = "You must be logged in to use this feature!"
      redirect_to login_path
    end
  end

  def store_route
    session[:return_route] = request.env['PATH_INFO']
  end
end
