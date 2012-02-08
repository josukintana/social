class User < ActiveRecord::Base
  include ProfilesManagement
    
  include GroupsManagement
end
