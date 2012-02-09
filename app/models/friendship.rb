class Friendship < ActiveRecord::Base
  ACCEPTED = "accepted"
  PENDING = "pending"
  REQUESTED = "requested"
  
  belongs_to :user
  belongs_to :friend, :class_name => "User", :foreign_key => "friend_id"
end
