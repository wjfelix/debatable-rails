class User < ActiveRecord::Base
	has_many :debates
	has_many :debate_users, through: :debates
	has_secure_password
end
