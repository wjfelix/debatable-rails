class HomeController < ApplicationController
  def index
    if params[:session]
      redirect_to home_news
    end
  end

  def news
  end
end
