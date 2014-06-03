def get_tags()
  get_story["tags"]
end

def get_tag_id()
  session[:current_tag]
end

def get_current_tag()
  # load params from session
  get_tags[get_tag_id]
end

def merge_current_tag!(data)
  # save params to session
  get_current_tag.merge!(data)
end

def is_a_tag_id(id)
  true # id > 0 or get_tag_count < id
end

def switch_to_tag!(id)
  session[:current_tag] = id
end

def init_tag()
  key = SecureRandom.uuid
  switch_to_tag(key)
  get_tags[key] = {}
end

def has_previous_tag()
  false # return get_tag_id > 1
end

def has_next_tag()
  false #return get_tag_id < get_tag_count
end

def url_for_previous_tag()
  if has_previous_tag then
    return '/mystories/edit/tag/' + (get_tag_id - 1).to_s
  end
  "#"
end

def url_for_next_tag()
  if has_next_tag then
    return '/mystories/edit/tag/' + (get_tag_id + 1).to_s
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
  get_tags.length
end

def is_current_tag_id(id)
  id.to_s == get_tag_id.to_s
end

# quiz

def get_quiz()
  return get_current_tag["quiz"] unless get_current_tag["quiz"].nil?
  get_current_tag["quiz"] = [{}]
end

def save_quiz(quiz)
  quiz.each_with_index do | elem, i |
    get_quiz[i].merge!(quiz[i])
  end
end

def add_question()
  get_quiz.concat([{}])
end

# options

def get_options()
  return get_current_tag["options"] unless get_current_tag["options"].nil?
  get_current_tag["options"] = [{}]
end

def save_options(options)
  options.each_with_index do | elem, i |
    get_options[i].merge!(options[i])
  end
end

def add_option()
  get_options.concat([{}])
end

def delete_option(index)
  get_options.delete_at(index.to_i)
  if  get_options.length == 0 then
    add_option
  end
end