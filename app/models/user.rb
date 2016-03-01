class User < ActiveRecord::Base
	before_create :validate_code
	before_create :save_fullname
	has_many :debates
	has_many :firetalks
	has_many :debate_users
	has_many :firetalk_users
	has_many :posts
	has_many :debater_invites
	has_many :moderator_invites
	has_many :notifications

	has_secure_password
	validates :password, presence: true, confirmation: true, length: { minimum: 7 }
	validates_uniqueness_of :email, :case_sensitive => false

	private
	def validate_code
		if self.validation_code.nil? || self.validation_code.blank
			self.validation_code = SecureRandom.urlsafe_base64.to_s
		end
	end

	def save_fullname
		self.fullname = self.firstname + " " + self.lastname
	end
end
