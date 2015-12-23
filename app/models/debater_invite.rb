class DebaterInvite < ActiveRecord::Base

  after_create :send_invite

  belongs_to :debate

  private
  def send_invite
  end
end
