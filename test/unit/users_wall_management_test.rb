require 'test_helper'

class UsersWallManagementTest < ActiveSupport::TestCase
  
  def setup
    @peter = users(:peter)
  end
  
  test "add a wall to a user" do
    wall = @peter.create_my_wall
    
    assert !@peter.wall.nil?
    assert_equal "peter@email.com", wall.user.email
  end
  
end