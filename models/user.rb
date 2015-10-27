class User < ActiveRecord::Base
  has_many :authorgroups, :dependent => :destroy
  has_many :stories, through: :authorgroups

  def can_edit_story(id)
    self.authorgroups.each do | group |
      if group.story_id == id
        return true
      end
    end
    return false
  end

  def self.create_user(info, uid)
    User.create(
                username: info[:name],
                first_name: info[:first_name],
                last_name: info[:last_name],
                email: info[:email],
                image: info[:image],
                uid: uid,
                )
  end
end
