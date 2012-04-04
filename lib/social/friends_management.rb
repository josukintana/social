module FriendsManagement
  def self.included(base)
    base.send :include, InstanceMethods
    base.send :extend, ClassMethods
    base.send :initialize
  end
  
  module InstanceMethods
    def non_friends
      User.where("id != ?", self.id) - self.friends #My non_friends are all the users but me and my friends
    end
    
    def is_friend_of?(friend)
      # Determines if a user is already a friend of mine
      self.friends.include?(friend)
    end
    
    def is_blocked_by?(friend)
      friend.blocked_friends.include?(self)
    end
    
    def can_request_to?(friend)
      ((!self.is_friend_of?(friend)) && (!self.pending_friends.include?(friend)) && (!self.requested_friends.include?(friend)))
    end
    
    def request_friendship_to(friend)
      if (self.can_request_to?(friend))     #Only someone who is not still my friend can be requested
        friend.friendships.create(:friend_id => self.id, :status => Friendship::PENDING) if !self.is_blocked_by?(friend)
        !friend.is_blocked_by?(self) ? self.friendships.create(:friend_id => friend.id, :status => Friendship::REQUESTED) : self.email + " cannot request " + friend.email + "'s friendship because he/she has previously blocked that user."
      end
    end
    
    def cancel_request_to(friend)
      if (self.requested_friends.include?(friend))
        self.friendships.by_friend(friend).requested.first.destroy #Cancel my friendship request.
        friend.friendships.by_friend(self).pending.first.destroy #Cancel my friend's pending request.
        self.email + "'s friendship request to " + friend.email + " has been correctly canceled."
      end
    end
    
    def accept_friendship_of(friend)
      if (self.pending_friends.include?(friend))
        self.friendships.by_friend(friend).pending.first.accept #I'm the friend of my friend.
        friend.friendships.by_friend(self).requested.first.accept #My friend is a friend of mine.
        self.email + " and " + friend.email + " are now friends."
      end
    end
    
    def reject_friendship_of(friend)
      if (self.pending_friends.include?(friend))
        self.friendships.by_friend(friend).pending.first.destroy #My friendship is destroyed.
        friend.friendships.by_friend(self).requested.first.reject #My friend's friendship is marked as rejected.
        self.email + " has correctly rejected " + friend.email + "'s friendship request."
      end
    end
    
    def cancel_friendship_with(friend)
      if (self.is_friend_of?(friend))
        self.friendships.by_friend(friend).accepted.first.destroy #My friendship is destroyed.
        friend.friendships.by_friend(self).accepted.first.destroy #My friend's friendship is destroyed.
        self.email + " and " + friend.email + " are not friends anymore."
      else
        self.email + " is not a friend of" + friend.email + "."
      end
    end
    
    def block_friend(friend)
      if ((self.can_request_to?(friend)) && (!self.blocked_friends.include?(friend)))
        self.friendships.create(:friend_id => friend.id, :status => Friendship::BLOCKED) #My friendship is blocked.
        self.email + " has correctly blocked " + friend.email + "."
      else
        "The user " + friend.email + " couldn't be blocked by " + self.email + "." 
      end
    end
    
    def unblock_friend(friend)
      if (self.blocked_friends.include?(friend))
        self.friendships.by_friend(friend).first.destroy #The blocked friendship is destroyed.
        self.email + " has correctly unblocked " + friend.email + "."
      else
        "The user " + friend.email + " wasn't blocked by " + self.email + "." 
      end
    end
  end
 
  module ClassMethods
    def initialize
      has_many :friendships, :dependent => :destroy
      has_many :friends, :through => :friendships, :conditions => "status = 'accepted'"
      has_many :requested_friends, :through => :friendships, :source => :friend, :conditions => "status = 'requested'", :order => :created_at
      has_many :pending_friends, :through => :friendships, :source => :friend, :conditions => "status = 'pending'", :order => :created_at
      has_many :blocked_friends, :through => :friendships, :source => :friend, :conditions => "status = 'blocked'", :order => :created_at
    end
  end
end