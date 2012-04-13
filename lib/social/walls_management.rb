module WallsManagement
  
  def self.included(base)
    #base.send :include, InstanceMethods
    base.send :extend, ClassMethods
    base.send :initialize
  end
 
 
  module ClassMethods
    
    def initialize
      attr_accessible :user_id
      belongs_to :user
      has_many :wallevents
      has_many :activities, :through => :wallevents
                      
      validates :user_id, :presence => true
    end
    
  end
  
end