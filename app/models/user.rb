class User < ActiveRecord::Base
  include ProfilesManagement
  #include GroupsManagement
  include FriendsManagement
  include FollowmentManagement
end
