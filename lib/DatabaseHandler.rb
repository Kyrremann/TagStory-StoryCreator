# Cloudant connection
DB = "#{ENV['CLOUDANT_URL']}"
USER_ID = '7a89ad827876e3a207fda55b1ab9e510'

#users
private
def get_users_json_from_cloudant
  JSON.parse(RestClient.get("#{DB}/users/#{USER_ID}"))
end

def get_users_from_cloudant
  get_users_json_from_cloudant["users"]
end

def save_user_to_cloudant(uid, user)
  jdata = get_users_json_from_cloudant
  jdata["users"][uid] = user
  save_to_cloudant "users", jdata.to_json
end

private
def save_to_cloudant(table, json)
  begin
    @respons =  RestClient.post("#{DB}/#{table}", json, {:content_type => :json, :accept => :json})
    if @respons["ok"] then
      puts "OK"
    else
      p @respons
      # something bad :\
    end
  rescue => e
    p e
    # inform someone
  end
end
