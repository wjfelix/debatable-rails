require 'bcrypt'
require 'securerandom'

class UsersController < ApplicationController
  include BCrypt

  def index
    if (session[:user_id])
      @users = User.where.not(:id => session[:user_id])
      respond_to do |format|
        format.json {render :json => @users.where("fullname like ?", "%#{params[:q]}%")}
      end
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      UserMailer.email_validation(@user).deliver
      flash[:success] = true
      flash[:message] = "Account successfully created! Check your E-mail for a verification link"
      redirect_to root_url
    else
      flash[:success] = true
      flash[:message] = "You have not completed the required fields!"
      redirect_to new_user_path
    end
  end

  def show
    @user = User.find(params[:id])
    @total = []
    @debates = @user.debates
    @firetalks = @user.firetalks
    @firetalk_debaters = FiretalkDebater.where(:user_id => @user.id)

    @posts = @user.posts
    @debates.each do |debate|
      @total.push(debate)
    end
    @firetalks.each do |firetalk|
      @total.push(firetalk)
    end
    @firetalk_debaters.each do |firetalk_debater|
      @total.push(firetalk_debater)
    end
    @posts.each do |post|
      @total.push(post)
    end
    @total.sort_by! { |model| model.created_at.to_date}
  end

  def edit
  end

  def update
  end

  def validate_email
    user = User.find_by_validation_code(params[:user_id])

    if user
      worked = false
      sql = "UPDATE users SET is_validated = 1 WHERE id = #{user.id}"
      worked = ActiveRecord::Base.connection.execute(sql)
      flash[:success] = true
      flash[:message] = "E-mail successfully verified!"
      redirect_to login_path
    else
      flash[:success] = false
      flash[:message] = "Sorry, that user does not exist!"
      redirect_to login_path
    end
  end

  def forgot_password
  end

  def reset_password
    @user = User.find_by_email(params[:email])
    # make new password, and send new password to email
    temp_password = SecureRandom.hex(10)
    @user.password = temp_password
    if !@user
      flash[:success] = true
      flash[:message] = "Could not find user under that e-mail"
      redirect_to '/forgot_password'
    elsif @user.save!
      UserMailer.email_password(@user, temp_password).deliver
      flash[:success] = true
      flash[:message] = "Check your email for your new temporary password!"

      redirect_to '/login'
    else
      flash[:success] = true
      flash[:message] = "Error update your password, database error"
      redirect_to '/forgot_password'
    end
  end

  def change_password
    @user = User.find(session[:user_id])
  end

  def update_password
    @user = User.find(session[:user_id])
    if @user.authenticate(params[:user][:current_password]) && @user.update(password_params)
      flash[:success] = true
      flash[:message] = "Successfully updated password!"
      redirect_to '/'
    else
      flash[:success] = false
      flash[:message] = "Failed to update password, make sure they match"
      redirect_to '/change_password'
    end

  end

  private
  def user_params
    params.require(:user).permit(:firstname, :lastname, :email, :password, :password_confirmation)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
