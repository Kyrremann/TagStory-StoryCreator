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
  session[:expires_at] = authJson[:credentials][:expires_at]
  
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

def validate_user(refresh_token)
  data = {
    :client_id => G_API_CLIENT,
    :client_secret => G_API_SECRET,
    :refresh_token => refresh_token,
    :grant_type => "refresh_token"
  }

  begin
    @respons = JSON.parse(RestClient.post "https://accounts.google.com/o/oauth2/token", data)
    unless @respons["access_token"].nil?
      session[:acess_token] = @respons["access_token"]
      session[:expires_at] = Time.now.utc + @respons["expires_in"].to_i
      #@respons = JSON.parse(RestClient.get "https://www.googleapis.com/oauth2/v1/userinfo?access_token=#{session[:access_token]}")
      @respons = JSON.parse(RestClient.get "https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=#{session[:access_token]}")
      p @respons
      #uid = @respons["id"]
    else
      # No Token
      p @respons
    end
  rescue => e
    p e
  end
end

def logged_in?
  session[:access_token]
end

def get_uid
  session[:uid]
end

def get_user_image
  session[:info][:image]
end

def get_full_name
  session[:info][:name]
end
