def get_story(id)

end

def get_story_json(id)
  get_story_json_from_cloudant id
end

def get_current_story(id)
  get_story_json_from_cloudant(id)["story"]
end

def get_stories
  get_stories_json_from_cloudant
end

def get_user_stories
  @doc = RestClient.get("#{DB}/stories/_design/lists/_search/editors?q=" + get_uid)
  @result = JSON.parse(@doc)["rows"]
end

def save_story(id, data)
  story = get_story_json id
  story["story"].merge! data
  save_story_to_cloudant story
end
