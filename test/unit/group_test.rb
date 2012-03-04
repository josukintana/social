require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @peter = users(:peter)
    @fred = users(:fred) 
  end
  
  test "add a member to a group" do
    @peter.groups.first.add_member(@fred)
    assert @peter.groups.first.members.include?(@fred)
  end
  
  test "remove a member from a group" do
    @peter.groups.first.remove_member(@john)
    assert !@peter.groups.first.members.include?(@john)
  end
  
end
