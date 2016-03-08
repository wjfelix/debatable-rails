class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :store_location
  before_filter :grab_invites
  before_filter :grab_new_topic

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    return unless request.get?
    if (request.path != "/login" &&
        request.path != "/users/new" &&
        !request.path.include?("validate_email") &&
        request.path != "/logout" &&
        !request.xhr?) # don't store ajax calls
      session[:return_route] = request.fullpath
    end
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  def grab_invites
    if (session[:user_id])
      @user = User.find(session[:user_id])
      @invites = @user.invites
    end
  end

  def grab_new_topic
    # set @topic
    @topic = "TestTosdfsspic1"

    # get the topic of the day!!
    response = HTTParty.get('http://www.google.com/trends/hottrends/atom/feed')
    xml_doc  = Nokogiri::XML(response)
    @topics = []
    xml_doc.xpath('//title').each do |char_element|
      if (char_element.text != 'Hot Trends')
        @topics.push(char_element.text)
      end
    end
    #@topic = @topics[0]
  end
end
