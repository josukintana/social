module UsersHelper
  def get_all_users
     @users = User.find(:all)
  end
end
