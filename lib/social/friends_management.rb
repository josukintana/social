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
      if (self.non_friends.include?(friend))
        return false  
      else
        return true
      end
    end
    
    def is_blocked_by?(friend)
      if (friend.blocked_friends.include?(self))
        return true  
      else
        return false
      end
    end
    
    def can_request_to?(friend)
      if ((!self.is_friend_of?(friend)) && (!self.pending_friends.include?(friend)) && (!self.requested_friends.include?(friend)))
        #We are not friends and we are not in process to be
        return true
      else
        return false
      end
    end
    
    def request_friendship_to(friend)
      if (self.can_request_to?(friend))     #Only someone who is not still my friend can be requested
        if (!friend.is_blocked_by?(self))
          self.friendships.create(:friend_id => friend.id, :status => Friendship::REQUESTED)
          return self.email + " has correctly requested " + friend.email + "'s friendship."   
        else
          return self.email + " cannot request " + friend.email + "'s friendship because he/she has previously blocked that user."
        end
        
        if (!self.is_blocked_by?(friend)) #If my friend has not blocked me, he'll be notified about my request
          friend.friendships.create(:friend_id => self.id, :status => Friendship::PENDING)
        end
      end
    end
    
    def cancel_request_to(friend)
      if (self.requested_friends.include?(friend))
        self.friendships.by_friend(friend).requested.first.destroy #Cancel my friendship request.
        return self.email + "'s friendship request to " + friend.email + " has been correctly canceled."
      end
    end
    
    def accept_friendship_of(friend)
      if (self.pending_friends.include?(friend))
        self.friendships.by_friend(friend).pending.first.accept #I'm the friend of my friend.
        friend.friendships.by_friend(self).requested.first.accept #My friend is a friend of mine.
        return self.email + " and " + friend.email + " are now friends."
      end
    end
    
    def reject_friendship_of(friend)
      if (self.pending_friends.include?(friend))
        self.friendships.by_friend(friend).pending.first.destroy #My friendship is destroyed.
        friend.friendships.by_friend(self).requested.first.reject #My friend's friendship is marked as rejected.
        return self.email + " has correctly rejected " + friend.email + "'s friendship request."
      end
    end
    
    def cancel_friendship_with(friend)
      if (self.is_friend_of?(friend))
        self.friendships.by_friend(friend).first.destroy #My friendship is destroyed.
        friend.friendships.by_friend(self).first.destroy #My friend's friendship is destroyed.
        return self.email + " and " + friend.email + " are not friends anymore."
      else
        return self.email + " is not a friend of" + friend.email + "."
      end
    end
    
    def block_friend(friend)
      if ((self.can_request_to?(friend)) && (!self.blocked_friends.include?(friend)))
        self.friendships.create(:friend_id => friend.id, :status => Friendship::BLOCKED) #My friendship is blocked.
        return self.email + " has correctly blocked " + friend.email + "."
      else
        return "The user " + friend.email + " couldn't be blocked by " + self.email + "." 
      end
    end
    
    def unblock_friend(friend)
      if (self.blocked_friends.include?(friend))
        self.friendships.by_friend(friend).first.destroy #The blocked friendship is destroyed.
        return self.email + " has correctly unblocked " + friend.email + "."
      else
        return "The user " + friend.email + " wasn't blocked by " + self.email + "." 
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