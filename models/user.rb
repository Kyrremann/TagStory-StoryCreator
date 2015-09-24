class User < ActiveRecord::Base
  has_many :authorgroups, :dependent => :destroy
  has_many :stories, through: :authorgroups

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
