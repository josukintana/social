class User < ActiveRecord::Base
  include ProfilesManagement
  include GroupsManagement
  include FriendsManagement
end
