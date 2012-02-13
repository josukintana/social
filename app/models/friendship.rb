class Friendship < ActiveRecord::Base
  ACCEPTED = "accepted"
  PENDING = "pending" #A friendship is PENDING if it has been requested to me
  REQUESTED = "requested" #A friendship is REQUESTED if it has been requested by me
  REJECTED = "rejected" #A friendship is rejected if I have requested a friend and he has rejected my friendship
  BLOCKED = "blocked" #A friendship is BLOCKED if don't want to be requested anymore
  
  belongs_to :user
  belongs_to :friend, :class_name => "User", :foreign_key => "friend_id"
  
  scope :requested, lambda { where('status = ?', REQUESTED) }
  scope :pending, lambda { where('status = ?', PENDING) }
  scope :accepted, lambda { where('status = ?', ACCEPTED) }
  scope :blocked, lambda { where('status = ?', BLOCKED) }
  
  scope :by_friend, lambda { |friend| where( :friend_id => friend.id)}
          
  def accept
    self.status = ACCEPTED
    self.save
  end
  
  def reject
    self.status = REJECTED
    self.save
  end
end
