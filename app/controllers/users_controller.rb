class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = true
      flash[:message] = "Account successfully created! Check your E-mail for a verification link"
      redirect_to user_path(@user)
    else
      flash[:success] = false
      flash[:message] = "You have not completed the required fields!"
      redirect_to new_user_path
    end
  end

  def show
  end

  private
  def user_params
    params.require(:user).permit(:firstname, :lastname, :email, :password, :password_confirmation)
  end
end
