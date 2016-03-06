class RandomFiretalksController < ApplicationController
  before_filter :grab_new_topic

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

  def join
    # get all public firetalks who are not in progress with current topic
    # if no firetalks, make a new one
    @firetalks = Firetalk.where(:public => true, :in_progress => false, :topic => @topic, :full => false)
    if @firetalks.any?
      # join random one
      @firetalk = @firetalks.sample
      redirect_to user_firetalk_path(:id => @firetalk.id, :user_id => @firetalk.user_id)
    else
      # make new one
    end

  end

  def watch
    # go to firetalk as spectator which is public and in progress
  end
end
