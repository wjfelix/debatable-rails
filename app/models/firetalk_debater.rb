class FiretalkDebater < ActiveRecord::Base
  belongs_to :firetalk
  belongs_to :user
end
