class Group < ActiveRecord::Base
  # Setup accessible (or protected) attributes for your model
  
  has_many :activities
  has_many :memberships, :dependent => :destroy
  has_many :members, :through => :memberships, :source => :user
  has_one :ownership
  has_one :owner, :through => :ownership, :source => :user
  
  def add_member(user)
    if (!self.members.include?(user))
      self.members << user
      return user.email + " has been correctly added to the group '" + self.name + "'."
    else
      return user.email + " is already a member of '" + self.name + "'."
    end
  end

  def remove_member(user)
    if (self.members.include?(user))
      self.memberships.find_by_user_id(user.id).destroy
      #return user.email + " has been correctly removed from the group '" + self.name + "'."
    else
      #return user.email + " is not a member of the group '" + self.name + "'."
    end
    
  end
end
