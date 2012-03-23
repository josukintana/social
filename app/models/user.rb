class User < ActiveRecord::Base
  include ProfilesManagement
  include GroupsManagement
  include FriendsManagement
  include FollowmentManagement
  has_one :wall
end
