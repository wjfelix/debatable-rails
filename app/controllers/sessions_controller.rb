class SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by_email(params[:session][:username])

    if @user
      if !@user.is_validated
        flash[:success] = false
        flash[:message] = "You have not validated your account!" << @user.is_validated.to_s

        redirect_to login_path
      elsif @user.authenticate(params[:session][:password])
        session[:user_id] = @user.id

        flash[:success] = true
        flash[:message] = "Successfully logged in!"

        if session[:return_route]
          redirect_to session[:return_route]
        else
          redirect_to home_news_path
        end
      end
    else
      flash[:success] = false
      flash[:message] = "Incorrect Username or Password"

      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = true
    flash[:message] = "Successfully logged out!"
    redirect_to login_path
  end
end
