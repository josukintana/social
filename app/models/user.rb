class User < ActiveRecord::Base
  include ProfilesManagement
  include GroupsManagement
  include FriendsManagement
  include FollowmentManagement
  include UsersWallManagement
end
