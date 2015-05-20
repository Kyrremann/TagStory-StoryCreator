def get_story(id)
  get_story_json_from_cloudant(id)["story"]
end

def get_story_json(id)
  get_story_json_from_cloudant id
end

def get_current_story(id)
  get_story id
end

def get_story_id(uuid)
  @doc = RestClient.get("#{DB}/stories/_design/lists/_search/uuid?q=UUID:\"" + uuid + "\"")
  @result = JSON.parse(@doc)
  if (@result["total_rows"] == 1) then
    return @result["rows"][0]["id"]
  else
    return nil
  end
end

def get_stories
  get_stories_json_from_cloudant
end

def get_user_stories
  @doc = RestClient.get("#{DB}/stories/_design/lists/_search/editors?q=" + get_uid)
  @result = JSON.parse(@doc)["rows"]
end

def get_trashed_stories_for_user
  stories = get_user_stories
  stories.delete_if { | story |
    story["fields"]["status"] != "deleted"
  }
end

def get_non_deleted_user_stories
  stories = get_user_stories
  stories.delete_if { | story |
    story["fields"]["status"] == "deleted"
  }
end

def create_new_story
  id = SecureRandom.uuid
  value = { 
    "story" => { 
      "UUID" => id,
      "author" => get_full_name,
      "editors" => [ get_uid ],
      "title": "New story",
      "genre": "draft",
      "description" => "Please fill in a description about your story",
      "image" => "placeimg_960_720_nature_1.jpg",
      "status" => "draft",
      "version" => 1
    }
  }
  @respons = save_story_to_cloudant value
  if @respons["ok"] then
    return @respons["id"]
  else
    nil
  end
end

def delete_soft_story(id)
  story = get_story id
  story["status"] = "deleted"
  save_story id, story
end

def delete_hard_story(id)
  delete_story_from_cloudant id
end

def delete_soft_story(id)
  story = get_story id
  story['status'] = 'draft'
  save_story id, story
end

def save_story(id, data)
  story = get_story_json id
  story["story"].merge! data
  save_story_to_cloudant story
end

def save_story_from_params(storyId, params)
  delete_common_params_key! params
  save_story storyId, params
end

def save_tag_from_params(tagId, storyId, params)
  delete_common_params_key! params
  save_tag tagId, storyId, params
end

def save_option_from_params(optionId, tagId, storyId, params)
  delete_common_params_key! params
  save_option optionId, tagId, storyId, params
end

def add_tag(tagId, storyId)
  story = get_story_json storyId
  unless story["story"].has_key? 'tags' then
    story["story"]["tags"] = {}
  end
  story["story"]["tags"][tagId] = {"options": []}
  save_story_to_cloudant story
end

def remove_tag(tagId, storyId)
  story = get_story_json storyId
  story["story"]["tags"].delete tagId
  save_story_to_cloudant story
end

def save_tag(tagId, storyId, params)
  story = get_story_json storyId
  story["story"]["tags"][tagId].merge! params
  save_story_to_cloudant story
end

def add_option(tagId, storyId)
  story = get_story_json storyId
  unless story["story"]['tags'][tagId].has_key? 'options' then
    story["story"]['tags'][tagId]['options'] = []
  end
  story["story"]["tags"][tagId]["options"] << {}
  save_story_to_cloudant story
  story["story"]["tags"][tagId]["options"].length - 1
end

def save_option(optionId, tagId, storyId, params)
  story = get_story_json storyId
  story["story"]["tags"][tagId]["options"][optionId].merge! params
  save_story_to_cloudant story
end

def remove_option(optionId, tagId, storyId)
  story = get_story_json storyId
  story["story"]["tags"][tagId]["options"].delete_at optionId
  save_story_to_cloudant story
end

private
def delete_common_params_key!(params)
  params.delete "save"
  params.delete "add_tag"
  params.delete "add_option"
  params.delete "captures"
  params.delete "storyId"
  params.delete "tagId"
  params.delete "optionId"
  params.delete "splat"
end
