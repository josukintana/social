module FriendsManagement
  def self.included(base)
    base.send :include, InstanceMethods
    base.send :extend, ClassMethods
    base.send :initialize
  end
  
  module InstanceMethods
    def non_friends
      User.find(:all) - self.friends
    end
    
    def request_friend(friend)
      self.friendships.create(:friend_id => friend.id, :status => Friendship::REQUESTED)
      friend.friendships.create(:friend_id => self.id, :status => Friendship::PENDING)
    end
    
    def cancel_request(friend)
      self.friendships.by_friend(friend).requested.destroy
    end
    
    def pending_friends
      self.friendships.pending.each do |pending_friendship|
        pending_friendship.friend
      end
    end
    
    def requested_friends
      self.friendships.requested.each do |requested_friendship|
        requested_friendship.friend
      end
    end
    
    def blocked_friends
      self.friendships.blocked
    end
    
    def accept_friend(friend)
      self.friendships.by_friend(friend).pending.first.accept #I'm the friend of my friend.
      friend.friendships.by_friend(self).requested.first.accept #My friend is a friend of mine.
    end
    
    def reject_friend(friend)
      self.friendships.by_friend(friend).pending.first.destroy #My friendship is destroyed.
      friend.friendships.by_friend(self).requested.first.reject #My friend's friendship is marked as rejected.
    end
    
    def cancel_friendship(friend)
      self.friendships.by_friend(friend).first.destroy #My friendship is destroyed.
      friend.friendships.by_friend(self).first.destroy #My friend's friendship is destroyed.
    end
    
    def block_friend(friend)
      self.friendships.by_friend(friend).first.block #My friendship is blocked.
                                                     #My friends's friendship remains requested.
    end
  end
 
  module ClassMethods
    def initialize
      has_many :friendships, :dependent => :destroy
      has_many :friends, :through => :friendships, :conditions => "status = 'accepted'"
      has_many :requested_friends, :through => :friendships, :source => :friend, :conditions => "status = 'requested'", :order => :created_at
      has_many :pending_friends, :through => :friendships, :source => :friend, :conditions => "status = 'pending'", :order => :created_at
    end
  end
end