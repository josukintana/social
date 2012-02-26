require 'test_helper'

class UserTest < ActiveSupport::TestCase
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
  
  test "request friendship to another user" do
    @fred.request_friendship_to(@mary)
    
    assert @fred.requested_friends.include?(@mary), @fred.requested_friends.inspect
    assert @mary.pending_friends.include?(@fred), @mary.pending_friends.inspect
  end
  
  test "cancel requested friendship before being accepted" do
    @fred.request_friendship_to(@mary)
    
    @fred.cancel_request_to(@mary)
    
    assert !@fred.requested_friends.include?(@mary), @fred.requested_friends.inspect
  end
  
  test "accept a pending friendship" do
    @fred.request_friendship_to(@mary)
    
    @mary.accept_friendship_of(@fred)
    
    assert @mary.friends.include?(@fred), @mary.friends.inspect
    assert !@mary.pending_friends.include?(@fred), @mary.pending_friends.inspect
    assert !@fred.requested_friends.include?(@mary), @fred.requested_friends.inspect
    assert @fred.friends.include?(@mary), @fred.friends.inspect
  end
  
  test "cancel a user's friendship" do
    @fred.request_friendship_to(@mary)
    
    @mary.accept_friendship_of(@fred)
    
    assert @mary.friends.include?(@fred), @mary.friends.inspect
    assert !@mary.pending_friends.include?(@fred), @mary.pending_friends.inspect
    assert !@fred.requested_friends.include?(@mary), @fred.requested_friends.inspect
    assert @fred.friends.include?(@mary), @fred.friends.inspect
  end
  
  test "block another user" do
    assert !@fred.blocked_friends.include?(@mary), @fred.blocked_friends.inspect
    
    @fred.block_friend(@mary)
    
    assert @fred.blocked_friends.include?(@mary), @fred.blocked_friends.inspect
  end
  
  test "unblock a blocked user" do
    assert @mary.blocked_friends.include?(@peter), @mary.blocked_friends.inspect
    
    @mary.unblock_friend(@peter)
    
    assert !@mary.blocked_friends.include?(@peter), @mary.blocked_friends.inspect
  end
end
