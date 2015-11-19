class User < ActiveRecord::Base
	has_many :debates
	has_many :debate_users, through: :debates
	has_secure_password
	validates :password, presence: true, confirmation: true, length: { minimum: 7 }
end
