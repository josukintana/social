require 'test_helper'

class GroupsManagementTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @peter = users(:peter)
    @fred = users(:fred) 
  end
  
  test "check if a given group exists for a user" do
    assert @peter.group_exists?("Test Group")
  end
  
  test "add a group to a user" do
    @fred.add_group("Added Group")
    
    assert_equal @fred.groups.first.name, "Added Group"
  end
  
  test "remove a user's group" do
    @peter.remove_group("Test Group")
    
    assert !@peter.group_exists?("Test Group")
  end
  
end