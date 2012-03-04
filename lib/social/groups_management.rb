module GroupsManagement
  def self.included(base)
    base.send :include, InstanceMethods
    base.send :extend, ClassMethods
    base.send :initialize
  end
  
  module InstanceMethods
    def group_exists?(name)
      if (self.groups.find_by_name(name).nil?)
        return false
      else
        return true
      end
    end
    
    def add_group(name)
      if (!group_exists?(name))
        self.groups.create(:name => name)
        return "The group '" + name + "' has been correctly created."
      else
        return "The group '" + name + "' already exists."  
      end
    end
    
    def remove_group(name)
      if (group_exists?(name))
        self.groups.find_by_name(name).destroy
        return "The group '" + name + "' has been correctly removed."
      else
        return "The group '" + name + "' doesn't exist."
      end
    end
  end
 
  module ClassMethods
    def initialize
      has_many :memberships
      has_many :ownerships, :dependent => :destroy
      has_many :groups, :through => :ownerships
    end
  end
end