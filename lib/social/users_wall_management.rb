module UsersWallManagement
  def self.included(base)
    base.send :include, InstanceMethods
    base.send :extend, ClassMethods
    base.send :initialize
  end
 
  module InstanceMethods
    def create_my_wall
      Wall.create(:user_id => self.id)
    end
  end
 
  module ClassMethods
    def initialize
      has_one :wall
      has_many :activities
    end
  end
end