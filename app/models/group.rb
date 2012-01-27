class Group < ActiveRecord::Base
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :description, :member_ids
  
  validates :name, :presence => true
  
  has_many :memberships, :dependent => :destroy
  has_many :members, :through => :memberships, :source => :user
  has_many :ownerships
  has_one :owner, :through => :ownerships, :source => :user
end
