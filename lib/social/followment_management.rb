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
      self.non_followers.include?(user)
    end
    
    def is_following_to?(user)
      !self.non_followeds.include?(user)
    end
    
    def is_blocked_by?(friend)
      friend.blocked_friends.include?(self)
    end
    
    def follow(user)
      self.followments.create(:followed_id => user.id) if !self.is_following_to?(user)
      !self.is_following_to?(user) ? self.email + " is now following " + user.email + "." : self.email + " is already following " + user.email + "."
    end
    
    def unfollow(user)
      self.followments.find_by_followed_id(user.id).destroy if self.is_following_to?(user) #Only someone who is being followed can be unfollowed
      self.is_following_to?(user) ? self.email + " has just left following " + user.email + "." : self.email + " was not following " + user.email + "."
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