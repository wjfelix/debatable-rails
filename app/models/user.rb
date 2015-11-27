class User < ActiveRecord::Base
	before_create :validate_code
	has_many :debates
	has_many :debate_users
	has_many :posts
	has_secure_password
	validates :password, presence: true, confirmation: true, length: { minimum: 7 }

	private
	def validate_code
		if self.validation_code.nil? || self.validation_code.blank
			self.validation_code = SecureRandom.urlsafe_base64.to_s
		end
	end
end
