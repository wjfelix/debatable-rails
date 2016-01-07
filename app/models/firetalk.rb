class Firetalk < ActiveRecord::Base
  belongs_to :user
  has_many :firetalk_debaters
end
