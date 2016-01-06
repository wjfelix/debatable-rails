class HomeController < ApplicationController
  def index
    if session[:user_id]
      redirect_to home_news_path
    end
    @newslettersubscription = NewsletterSubscription.new
  end

  def save_subscription
    @newslettersubscription = NewsletterSubscription.new(new_params)
    if @newslettersubscription.save
      flash[:message] = true
      flash[:message] = "Successfully Subscribed!"
      redirect_to root_path
    end
  end

  def news
    @user = User.find(session[:user_id])
  end

  private
  def new_params
    params.require(:newsletter_subscription).permit(:email)
  end
end
