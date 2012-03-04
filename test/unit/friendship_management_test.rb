require 'test_helper'

class FriendShipManagenementTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  fixtures :users, :friendships
  
  def setup
    @fred = users(:fred)
    @mary = users(:mary)
    @peter = users(:peter)
    @john = users(:john)
  end
  
  test "check if two users are friends" do
    assert @peter.is_friend_of?(@john), @peter.friends.inspect
    assert @john.is_friend_of?(@peter), @john.friends.inspect
  end
  
  test "request friendship to another user" do
    @fred.request_friendship_to(@mary)
    
    assert @fred.requested_friends.include?(@mary), @fred.requested_friends.inspect
    assert @mary.pending_friends.include?(@fred), @mary.pending_friends.inspect
  end
  
  test "cancel requested friendship before being accepted" do
    @fred.cancel_request_to(@peter)
    
    assert !@fred.requested_friends.include?(@peter), @fred.requested_friends.inspect
    assert !@peter.pending_friends.include?(@fred), @peter.pending_friends.inspect
  end
  
  test "accept a friendship" do
    @peter.accept_friendship_of(@fred)
    
    assert @peter.friends.include?(@fred), @peter.friends.inspect
    assert !@peter.pending_friends.include?(@fred), @peter.pending_friends.inspect
    assert !@fred.requested_friends.include?(@peter), @fred.requested_friends.inspect
    assert @fred.friends.include?(@peter), @fred.friends.inspect
  end
  
  test "reject the friendship of somebody" do
    @peter.reject_friendship_of(@fred)
    
    assert !@peter.friends.include?(@fred), @peter.friends.inspect #Fred is not a friend of Peter
    assert !@fred.friends.include?(@peter), @fred.friends.inspect #Peter is not a friend of Fred
    
    assert_equal @fred.friendships.by_friend(@peter).first.status, Friendship::REJECTED, @fred.friendships.by_friend(@peter).inspect # Fred's request has been marked as rejected
    assert !@peter.pending_friends.include?(@fred), @peter.pending_friends.inspect #Peter has not any pending friendship from Fred
  end
  
  test "cancel a user's friendship" do
    @peter.cancel_friendship_with(@john)
    
    assert !@peter.friends.include?(@john), @peter.friends.inspect
    
    assert !@john.friends.include?(@peter), @john.friends.inspect
  end
  
  test "block another user" do
    @fred.block_friend(@mary)
    
    assert @fred.blocked_friends.include?(@mary), @fred.blocked_friends.inspect
  end
  
  test "unblock a blocked user" do
    @mary.unblock_friend(@peter)
    
    assert !@mary.blocked_friends.include?(@peter), @mary.blocked_friends.inspect
  end
end
