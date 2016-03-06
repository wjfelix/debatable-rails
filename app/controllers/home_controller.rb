class HomeController < ApplicationController
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
  require 'searchbing'
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

  def grab_new_topic
    # set @topic
    @topic = "Test Topic!"

    # get the topic of the day!!
    response = HTTParty.get('http://www.google.com/trends/hottrends/atom/feed')
    xml_doc  = Nokogiri::XML(response)
    @topics = []
    xml_doc.xpath('//title').each do |char_element|
      if (char_element.text != 'Hot Trends')
        @topics.push(char_element.text)
      end
    end
    @topic = @topics[0]
  end

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
    if session[:user_id]
      @user = User.find(session[:user_id])
      @bing_news = Bing.new('wQ4qB9R18dzlg2WTWasb2xoA/RRb9LzN5VfcbF197YI', 15, 'News')
      @news_items = @bing_news.search("")
    else
      flash[:message] = true
      flash[:message] = "You must be logged in to use this feature!"
      redirect_to login_path
    end
  end

  private
  def new_params
    params.require(:newsletter_subscription).permit(:email)
  end
end
