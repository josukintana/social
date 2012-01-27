class User < ActiveRecord::Base
  has_one :profile
  
  after_create :create_profile
  
  def create_profile
    profile = Profile.create(:user_id => self.id)
  end
end
