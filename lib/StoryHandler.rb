$story_map

def get_story_map()
  $story_map || $story_map = {}
end

def init_story()
  session[:story_id] = "new_story"
end

def load_story(id, story)
  get_story_map[id.to_s] = story
  set_story_id(id)
  key, value = get_tags.first
  switch_to_tag!(key)
end

def set_story_id(id)
  session[:story_id] = id
end

def get_story_id()
  session[:story_id]
end

def get_story()
  get_story_map[session[:story_id]] || get_story_map[session[:story_id]] = {}
end

def get_story_as_json()
  get_story.to_json
end

def get_from_story(key)
  get_story[key]
end

def merge_story!(data)
  get_story.merge!(data)
end

def is_a_story_id(uuid)
  true
end
