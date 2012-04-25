module ActivitiesManagement
  def self.included(base)
    base.send :include, InstanceMethods
    base.send :extend, ClassMethods
    base.send :initialize
  end
 
 
  module ClassMethods
    def initialize
      attr_accessible :text_comment_title, :text_comment, :img_file_name, :user_id, :group_id, :img,
                      :img_content_type, :img_file_size, :img_updated_at, :src_url, :user_fullname
                      
                      
      has_attached_file :img, {:styles => {:thumb => "114x114>", :medium => "216x156>"}}
      
      belongs_to :user
      belongs_to :group
      has_many :wallevents
      has_many :walls, :through => :wallevents
      
      validates :user_id, :presence => true
      
      
      default_scope order('created_at')
      
      after_create :update_activities_among_walls
    end
  end
  
  module InstanceMethods
    
    def update_activities_among_walls
      # IF the user dosn't select a particular group, then we apdate all friend's wall.
      !self.group.nil? ? self.group.members.each {|member| member.wall.activities << self if member.id != self.user_id} : self.user.friendships.each {|friendship| friendship.friend.wall.activities << self } 
    end
    
  end
end