require 'test_helper'

class FollowmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @fred = users(:fred)
    @mary = users(:mary)
    @peter = users(:peter)
  end
  
  test "follow a user" do
    @fred.follow(@mary)
    assert @mary.followers.include?(@fred), @mary.followers.inspect
  end

  test "unfollow a user" do
    @mary.unfollow(@peter)
    assert @peter.non_followers.include?(@mary), @peter.non_followers.inspect
  end
end
