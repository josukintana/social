require 'test_helper'

class FriendshipTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  user_1 = User.create(:email  => "user1@email.com")
  user_2 = User.create(:email  => "user2@email.com")
  
  test "request friendship to another user" do
    user_1.request_friendship_to(user_2)
    
    assert user_1.requested_friends.include?(user_2), user_1.requested_friends.inspect
    assert user_2.pending_friends.include?(user_1), user_2.pending_friends.inspect
  end
  
  test "cancel requested friendship before being accepted" do
    user_1.request_friendship_to(user_2)
    
    user_1.cancel_request_to(user_2)
    
    assert !user_1.requested_friends.include?(user_2), user_1.requested_friends.inspect
  end
  
  test "accept a pending friendship" do
    user_1.request_friendship_to(user_2)
    
    user_2.accept_friendship_of(user_1)
    
    assert user_2.friends.include?(user_1), user_2.friends.inspect
    assert user_1.friends.include?(user_2), user_1.friends.inspect
  end
end
