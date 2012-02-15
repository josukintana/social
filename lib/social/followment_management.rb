module FollowmentManagement
  def self.included(base)
    base.send :include, InstanceMethods
    base.send :extend, ClassMethods
    base.send :initialize
  end
  
  module InstanceMethods
    def non_followers
      User.where("id != ?", self.id) - self.followers #My non_friends are all the users but me and my friends
    end
    
    def non_followeds
      User.where("id != ?", self.id) - self.followeds #My non_friends are all the users but me and my friends
    end
    
    def is_followed_by?(user)
      if (self.non_followers.include?(user))
        return false  
      else
        return true
      end
    end
    
    def is_following_to?(user)
      if (self.non_followeds.include?(user))
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
    
    def follow(user)
      if (!self.is_following_to?(user))     #Only someone who is not being followed can be followed
          self.followments.create(:followed_id => user.id)
          return self.email + " is now following " + user.email + "."   
      else
        return self.email + " is already following " + user.email + "."
      end
    end
    
    def unfollow(user)
      if (self.is_following_to?(user))     #Only someone who is being followed can be unfollowed
          self.followments.find_by_followed_id(user.id).destroy
          return self.email + " has just left following " + user.email + "."   
      else
        return self.email + " was not following " + user.email + "."
      end
    end
  end
 
  module ClassMethods
    def initialize
      has_many :followments, :dependent => :destroy
      has_many :followings, :class_name => 'Followment', :foreign_key => 'followed_id'
      has_many :followeds, :through => :followments, :source => :followed
      has_many :followers, :class_name => 'User', :through => :followings
    end
  end
end