require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
 
  test "profile created at creating a user" do
    user_test = User.create(:email  => "test@email.com")
    assert_not_nil(user_test.profile)
  end
end
