class Group < ActiveRecord::Base
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :description, :member_ids
  
  has_many :memberships, :dependent => :destroy
  has_many :members, :through => :memberships, :source => :user
  has_one :ownership
  has_one :owner, :through => :ownership, :source => :user
  
  def add_member(user)
    self.members << user
  end

  def remove_member(user)
    self.memberships.find_by_user_id(user.id).destroy
  end
end
