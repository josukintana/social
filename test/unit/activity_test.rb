require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  def setup
    @fred = users(:fred)
    @fred_wall = walls(:fred_wall)
    
    @peter = users(:peter)
    @peter_wall = walls(:peter_wall)
    
    @fred.request_friendship_to(@peter)
    @peter.accept_friendship_of(@fred)
  end 
  
  test "Create an activity" do
    @fred_wall.activities.create(:user_id => @fred.id, :text_comment_title => 'title comment', :text_comment => 'text comment')
    
    assert_equal 1, @fred.wall.activities.count
  end
  
  test "Update wall activities friend's" do
    fred_activity = @fred_wall.activities.create(:user_id => @fred.id, :text_comment_title => 'title comment', :text_comment => 'text comment')
    peter_activity = @peter.wall.activities
    
    assert_equal 1, @peter.wall.activities.count
    assert_equal fred_activity.text_comment, peter_activity[0].text_comment
  end
  
  test "Update wall activities from a selected group members" do
    two_members_group = groups(:pgroup)
    two_members_group.add_member(@fred)
    two_members_group.add_member(@peter)
    @fred_wall.activities.create(:group_id => two_members_group.id, :user_id => @fred.id)
    
    assert_equal 2, Group.last.members.count
    assert_equal 1, @fred.wall.activities.count
    assert_equal 1, @peter.wall.activities.count
  end
  
end
