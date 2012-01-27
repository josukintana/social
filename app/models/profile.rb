class Profile < ActiveRecord::Base
  belongs_to :user
  
  attr_accessible :name, :sex, :birthdate, :user_id
end
