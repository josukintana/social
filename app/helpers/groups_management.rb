module GroupsManagement
  def self.included(base)
    base.send :include, InstanceMethods
    base.send :extend, ClassMethods
  end
 
  module InstanceMethods
    def add_group(name)
      self.groups.create(:name => name)
    end
    
    def remove_group(name)
      self.groups.find_by_name(name).destroy
    end
  end
 
  module ClassMethods
    def groupable
      has_many :memberships
      has_many :ownerships, :dependent => :destroy
      has_many :groups, :through => :ownerships
    end
  end
end