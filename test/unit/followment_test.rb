require 'test_helper'

class FollowmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  user_1 = User.create(:email  => "user1@email.com")
  user_2 = User.create(:email  => "user2@email.com")
  
  test "follow user" do
    user_1.follow(user_2)
    assert user_2.followers.include?(user_1), user_2.followers.inspect
  end

  test "unfollow user" do
    user_1.unfollow(user_2)
    assert user_2.non_followers.include?(user_1), user_2.non_followers.inspect
  end
end
