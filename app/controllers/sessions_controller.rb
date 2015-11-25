class SessionsController < ApplicationController

  def new
  end

  def create
    if session[:user_id]
      flash[:success] = false
      flash[:message] = "Already logged in! Press the 'Logout' button to sign in with a different account"
      redirect_to home_news_path
    end

    @user = User.find_by_email(params[:session][:username])

    if @user
      if !@user.is_validated
        flash[:success] = false
        flash[:message] = "You have not validated your account!"

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
      else
        flash[:success] = false
        flash[:message] = "Incorrect Username or Password"

        redirect_to login_path
      end
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = true
    flash[:message] = "Successfully logged out!"
    redirect_to login_path
  end
end
