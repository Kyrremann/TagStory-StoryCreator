
$header = {:content_type => :json, :accept => :json}

def save_story_to_database!()
  jdata = {}
  jdata["_id"] = get_story_id
  jdata["_rev"] = get_rev
  jdata["author"] = get_from_story("author")
  jdata["title"] = get_from_story("title")
  jdata["story"] = get_story
  begin
    @respons =  RestClient.post("#{DB}/stories/", jdata.to_json, $header)
    if @response["ok"] then
      set_rev(@respons["rev"])
    else
      # something bad :\
    end
  rescue => e
    p e.response
    # inform someone
  end
end

def create_story_in_database!()
  jdata = {}
  jdata["author"] = get_from_story("author")
  jdata["title"] = get_from_story("title")
  jdata["story"] = get_story
  begin
    @respons =  RestClient.post("#{DB}/stories/", jdata.to_json, $header)
    if @response["ok"] then
      set_rev(@respons["rev"])
      set_story_id(@respons["_id"])
    else
      # something bad :\
    end
  rescue => e
    p e.response
    # inform someone
  end
  
end
