class DebaterInvite < ActiveRecord::Base

  after_create :send_invite

  belongs_to :debate
  belongs_to :user
  
  private
  def send_invite
  end
end
