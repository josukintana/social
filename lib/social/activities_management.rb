module ActivitiesManagement
  def self.included(base)
    base.send :include, InstanceMethods
    base.send :extend, ClassMethods
    base.send :initialize
  end
 
 
  module ClassMethods
    def initialize
      attr_accessible :text_comment_title, :text_comment, :img_file_name, :user_id,
                      :img_content_type, :img_file_size, :img_updated_at, :src_url, :user_fullname
                      
                      
      #has_attached_file :img, {:styles => {:thumb => "114x114>", :medium => "216x156>"}}
      
      belongs_to :user
      has_many :wallevents
      has_many :walls, :through => :wallevents
      
      
      default_scope order('created_at')
      
      after_create :update_activities_among_walls
    end
  end
  
  module InstanceMethods
    def update_activities_among_walls
      friendships = self.user.friendships
      friendships.each {|friendship| friendship.friend.wall.activities << self }
    end
    
  end
end