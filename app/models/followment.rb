class Followment < ActiveRecord::Base
  belongs_to :follower, :foreign_key => "user_id", :class_name => 'Followment'
  belongs_to :followed, :class_name => 'User'
end
