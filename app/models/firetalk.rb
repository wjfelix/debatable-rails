class Firetalk < ActiveRecord::Base
  require 'opentok'
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

  before_create :save_tok_session_id

  #attr_accessible :user_ids
  belongs_to :user
  has_many :firetalk_debaters
  has_many :firetalk_messages
  has_many :users, :through => :firetalk_debaters

  accepts_nested_attributes_for :firetalk_debaters
  attr_reader :user_tokens
  #validates :user, presence: true

  def user_tokens=(ids)
    # TODO: validate users with ids, not working for now
    #self.user_ids = ids.split(",")
  end

  def random_firetalk(params)
    self.user_id = params[:user_id]
    self.topic = params[:topic]
    self.tok_session_id = params[:tok_session_id]
    self.name = "Random Firetalk!"
  end

  private
  def save_tok_session_id
    opentok = OpenTok::OpenTok.new '45241592', 'b099560439c52ed195d79cb7c15fbae1d9b33f1e'
    session = opentok.create_session
    self.tok_session_id = session.session_id
  end
end
