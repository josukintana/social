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
    
    def add_group(name, description = "")
      if (!group_exists?(name))
        self.groups.create(:name => name, :description => description)
        return "El grupo '" + name + "' ha sido correctamente creado."
      else
        return "El grupo '" + name + "' ya existe."  
      end
    end
    
    def remove_group(name)
      if (group_exists?(name))
        self.groups.find_by_name(name).destroy
        return "El grupo '" + name + "' ha sido correctamente eliminado."
      else
        return "El grupo '" + name + "' no existe."
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