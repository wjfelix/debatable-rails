class Debate < ActiveRecord::Base
	require 'opentok'
	OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

	before_create :save_tok_session_id

	belongs_to :user
	belongs_to :category
	belongs_to :debate_style
	has_many :debate_users
	has_many :debater_invites
	has_many :moderator_invites

	accepts_nested_attributes_for :debater_invites
	accepts_nested_attributes_for :moderator_invites

	private
	def save_tok_session_id
		opentok = OpenTok::OpenTok.new '45241592', 'b099560439c52ed195d79cb7c15fbae1d9b33f1e'
		session = opentok.create_session
		self.tok_session_id = session.session_id
	end
end
