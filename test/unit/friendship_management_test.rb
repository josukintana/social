require 'test_helper'

class FriendShipManagenementTest < ActiveSupport::TestCase
  
  fixtures :users, :friendships
  
  def setup
    @fred = users(:fred)
    @mary = users(:mary)
    @peter = users(:peter)
    @john = users(:john)
  end
  
  test "check if two users are friends" do
    assert @peter.is_friend_of?(@john)
    assert @john.is_friend_of?(@peter)
  end
  
  test "request friendship to another user" do
    @fred.request_friendship_to(@mary)
    
    assert @fred.requested_friends.include?(@mary)
    assert @mary.pending_friends.include?(@fred)
  end
  
  test "cancel requested friendship before being accepted" do
    @fred.cancel_request_to(@peter)
    
    assert !@fred.requested_friends.include?(@peter)
    assert !@peter.pending_friends.include?(@fred)
  end
  
  test "accept a friendship" do
    @peter.accept_friendship_of(@fred)
    
    assert @peter.friends.include?(@fred)
    assert !@peter.pending_friends.include?(@fred)
    assert !@fred.requested_friends.include?(@peter)
    assert @fred.friends.include?(@peter)
  end
  
  test "reject the friendship of somebody" do
    @peter.reject_friendship_of(@fred)
    
    assert !@peter.friends.include?(@fred) #Fred is not a friend of Peter
    assert !@fred.friends.include?(@peter) #Peter is not a friend of Fred
    
    assert_equal @fred.friendships.by_friend(@peter).first.status, Friendship::REJECTED, @fred.friendships.by_friend(@peter).inspect # Fred's request has been marked as rejected
    assert !@peter.pending_friends.include?(@fred) #Peter has not any pending friendship from Fred
  end
  
  test "cancel a user's friendship" do
    @peter.cancel_friendship_with(@john)
    
    assert !@peter.friends.include?(@john)
    assert !@john.friends.include?(@peter)
  end
  
  test "block another user" do
    @fred.block_friend(@mary)
    
    assert @fred.blocked_friends.include?(@mary)
  end
  
  test "unblock a blocked user" do
    @mary.unblock_friend(@peter)
    
    assert !@mary.blocked_friends.include?(@peter)
  end
end
