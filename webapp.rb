require_relative 'lib/Setup.rb'

before do
  content_type :html, 'charset' => 'utf-8'
end

get '/' do
  haml :index
end

get '/login' do
  redirect '/auth/google_oauth2'
end

# new story
# TODO

# edit story

# story wizard
get '/mystories/wizard/story/tag' do
  haml :wizard_tag
end

post '/mystories/wizard/story/tag' do
  p params
  if params["add_tag"] then
    redirect '/mystories/wizard/story/tag'
  elsif params["add_option"] then
    redirect '/mystories/wizard/story/tag/option'
  else
    redirect '/mystories/wizard/story/tag'
  end
end

get '/mystories/wizard/story/tag/option' do
  haml :wizard_tag_option
end

post '/mystories/wizard/story/tag/option' do
  p params
  if params["add_tag"] then
    redirect '/mystories/wizard/story/tag'
  else
    redirect '/mystories/wizard/story/tag/option'
  end
end

get '/mystories/wizard/:storyId' do | storyId |
  haml :wizard_story, :locals => {
    :params => get_current_story(storyId),
    :storyId => storyId
  }
end

post '/mystories/wizard/:storyId' do | storyId |
  p params
  if params.has_key? "save" then
    params.delete "save"
    params.delete "captures"
    params.delete "storyId"
    params.delete_if { | key, value | 
      value.empty?
    }
    save_story storyId, params
    redirect '/mystories/wizard/' + storyId
  end
  
  redirect '/'
end

# edit story
get '/mystories/edit/story/:storyId/:tagId/:optionId' do | storyId, tagId, optionId |
  story = get_current_story storyId
  haml :wizard_tag_option, :locals => {
    :params => story["tags"][tagId]["options"][optionId],
    :storyId => storyId,
    :tagId => tagId,
    :optionId => optionId,
    :tags => story["tags"]
  }
end

get '/mystories/edit/story/:storyId/:tagId' do | storyId, tagId |
  story = get_current_story storyId
  haml :wizard_tag, :locals => {
    :params => story["tags"][tagId],
    :storyId => storyId,
    :tagId => tagId,
    :tags => story["tags"]}
end

get '/mystories/edit/story/:storyId' do | storyId |
  # Set storyId as current story and then redirect to the wizard
  redirect '/mystories/wizard/' + storyId
end

# my stories
get '/mystories' do
  haml :mystories, :locals => { :stories => get_user_stories }
end

# other
get '/stories' do
  haml :stories, :locals => { :stories => get_stories }
end

get '/stories/json' do
  content_type :json, 'charset' => 'utf-8'
  get_stories.to_json
end

get '/story/:id/json' do | id |
  content_type :json, 'charset' => 'utf-8'
  get_story_json(id).to_json
end

# sign in
get '/auth/:provider/callback' do
  content_type 'text/plain'
  begin
    log_in_user request.env['omniauth.auth']
    redirect '/'
  rescue => e
    puts "User was not logged in with request #{request.env}"
    puts e
    redirect '/'
  end
end

get '/auth/failure' do
  content_type 'text/plain'
  begin
    request.env['omniauth.auth'].to_hash.inspect
  rescue => e
    puts "User could not log in with request #{request.env}"
    puts e
    redirect '/'
  end
end
