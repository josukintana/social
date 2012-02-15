class Group < ActiveRecord::Base
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :description, :member_ids
  
  has_many :memberships, :dependent => :destroy
  has_many :members, :through => :memberships, :source => :user
  has_one :ownership
  has_one :owner, :through => :ownership, :source => :user
  
  def add_member(user)
    if (!self.members.include?(user))
      self.members << user
      return user.email + " ha sido correctamente anadido al grupo '" + self.name + "'."
    else
      return user.email + " ya pertenece al grupo '" + self.name + "'."
    end
  end

  def remove_member(user)
    if (self.members.include?(user))
      self.memberships.find_by_user_id(user.id).destroy
      return user.email + " ha sido correctamente eliminado del grupo '" + self.name + "'."
    else
      return user.email + " no es miembro del grupo '" + self.name + "'."
    end
    
  end
end
