class User < ActiveRecord::Base
  has_one :profile
  
  after_create :create_profile
  
  has_many :memberships
  has_many :ownerships, :dependent => :destroy
  has_many :groups, :through => :ownerships
  
  def create_profile
    profile = Profile.create(:user_id => self.id)
  end
end
