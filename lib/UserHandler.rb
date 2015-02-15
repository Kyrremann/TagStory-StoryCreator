def get_users
  get_users_from_cloudant
end

def save_user(uid, info)
  save_user_to_cloudant uid, info
end

def get_unknown_user(uid)
  users = get_users
  users.each do | key, user |
    if user["ids"].include? uid then
      user = users[key]
      user["id"] = key
      return user
    end
  end
  nil
end

def get_statistic(uid)
  get_statistic_from_cloudant uid
end
