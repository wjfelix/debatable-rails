class Firetalk < ActiveRecord::Base
  require 'opentok'
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

  before_create :save_tok_session_id

  #attr_accessible :user_ids
  belongs_to :user
  has_many :firetalk_debaters
  has_many :users, :through => :firetalk_debaters
  #accepts_nested_attributes_for :firetalk_debaters
  attr_reader :user_ids

  def user_tokens=(ids)
    self.user_ids = ids.split(",");
  end

  private
  def save_tok_session_id
    opentok = OpenTok::OpenTok.new '45241592', 'b099560439c52ed195d79cb7c15fbae1d9b33f1e'
    session = opentok.create_session
    self.tok_session_id = session.session_id
  end
end
