class Debate < ActiveRecord::Base
	belongs_to :user
	has_many :debate_users
	has_many :debate_invites
end
