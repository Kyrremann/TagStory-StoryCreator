# stories
def get_story()
  # load params from session
  # use session[:session_id][:story] or make a Story object...
  return $story
end

def merge_story!(data)
  # save params to session
  get_story.merge!(data)
end

# tags
def get_tag_id()
  return $current_tag
end

def get_current_tag()
  # load params from session
  return $story[:parts][get_tag_id]
end

def merge_current_tag!(data)
  # save params to session
  get_current_tag.merge!(data)
end

def is_a_tag_id(id)
  if id < 0\
    or get_tag_count < id then
    return false
  end
  return true
end

def switch_to_tag!(id)
  $current_tag = id
end

def add_and_show_new_tag()
  if get_story[:parts][$current_tag].nil?
    if get_tag_count == 0 then
      $current_tag = 1
    end
    $story[:parts][$current_tag] = {}
  else
    $current_tag += 1
    return add_and_show_new_tag
  end

  redirect '/create/tag'
end

def has_previous_tag()
  return get_tag_id > 1
end

def has_next_tag()
  return get_tag_id < get_tag_count
end

def url_for_previous_tag()
  if has_previous_tag then
    return '/create/tag/' + (get_tag_id - 1).to_s
  end

  return "#"
end

def url_for_next_tag()
  if has_next_tag then
    return '/create/tag/' + (get_tag_id + 1).to_s
  end

  return "#"
end

def has_previous_tag_class()
  unless has_previous_tag then
    return "disabled"
  end
end

def has_next_tag_class()
  unless has_next_tag then
    return "disabled"
  end
end

def is_current_tag_active(id)
  if is_current_tag_id(id) then
    return "active"
  else
    ""
  end
end

def get_tag_count()
  return get_story[:parts].length
end

def is_current_tag_id(id)
  return id == get_tag_id
end
