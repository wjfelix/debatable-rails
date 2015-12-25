module ApplicationHelper
  def broadcast(channel, &block)
    invitation = {:channel => channel, :data => capture(&block)}
    uri = URI.parse('http://localhost:9292/faye')
    Net::HTTP.post_form(uri, :invitation => invitation.to_json)
  end
end
