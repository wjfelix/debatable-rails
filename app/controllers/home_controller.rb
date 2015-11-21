class HomeController < ApplicationController
  def index
    if params[:session]
      redirect_to home_news
    end
  end

  def news
    @user = User.find(session[:user_id])
  end
end
