class Authorgroup < ActiveRecord::Base
  belongs_to :story
  belongs_to :user

  def get_users_name
    user = User.find(self.user_id)
    if user
      return user.username
    else
      return 'Unknown'
    end
  end
end
