class HomeController < ApplicationController
  def index
    if session[:user_id]
      redirect_to home_news_path
    end
  end

  def news
    @user = User.find(session[:user_id])
  end
end
