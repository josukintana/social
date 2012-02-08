class Ownership < ActiveRecord::Base
  belongs_to :user, :dependent => :destroy
  belongs_to :group
  
  attr_accessible :group_id, :user_id
end
