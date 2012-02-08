module ProfilesManagement
  def self.included(base)
    base.send :include, InstanceMethods
    base.send :extend, ClassMethods
  end
 
  module InstanceMethods
    def create_profile
      Profile.create(:user_id => self.id)
    end
  end
 
  module ClassMethods
    def profileable
      has_one :profile
      
      after_create :create_profile
    end
  end
end