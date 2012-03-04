require 'test_helper'

class FriendshipTest < ActiveSupport::TestCase
  
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @requested_friendship = friendships(:four)
  end
  
  test "accept a friendship" do
    @requested_friendship.accept
    assert_equal @requested_friendship.status, Friendship::ACCEPTED
  end
  
  test "reject a friendship" do
    @requested_friendship.reject
    assert_equal @requested_friendship.status, Friendship::REJECTED
  end

end
