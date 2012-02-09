module FriendsManagement
  def self.included(base)
    base.send :include, InstanceMethods
    base.send :extend, ClassMethods
    base.send :initialize
  end
  
  module InstanceMethods
    def get_non_friends
      User.find(:all) - self.friends
    end
    
    def add_friend(friend)
      self.friendships.create(:friend_id => friend.id, :status => Friendship::PENDING)
      friend.friendships.create(:friend_id => self.id, :status => Friendship::REQUESTED)
    end
    
    def accept_friend(friend)

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