def log_in_user(authJson)
  users = get_users_from_cloudant

  uid = nil
  users.each do | key, user |
    if user["ids"].include? authJson["uid"] then
      uid = key
      break
    end
  end

  session[:access_token] = authJson[:credentials][:token]
  session[:refresh_token] = authJson[:credentials][:refresh_token]
  
  session[:info] = authJson[:info]
  raw = authJson[:extra][:raw_info]
  session[:info] << {
    :gender => raw[:gender],
    :birthday => raw[:birthday],
    :locale => raw[:locale]
  }
  
  unless uid then
    uid = SecureRandom.uuid
    session[:info][:ids] = [ authJson["uid"] ]
  else
    session[:info][:ids] = users[uid]["ids"]
  end

  session[:uid] = uid

  # always update information
  save_user_to_cloudant session[:uid], session[:info]
end

def logged_in?
  session[:uid]
end

def get_uid
  session[:uid]
end

def get_user_image
  session[:info][:image]
end
