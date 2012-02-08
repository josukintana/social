class Membership < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  
  attr_accessible :group_id, :user_id
end
