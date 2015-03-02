require 'rubygems'
require 'bundler/setup'
require 'sinatra'

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
get '/mystories/new/story' do
  storyId = create_new_story
  redirect '/mystories/wizard/' + storyId
end

# edit story
get '/mystories/edit/story/:storyId' do | storyId |
  # Set storyId as current story and then redirect to the wizard
  redirect '/mystories/wizard/' + storyId
end

# delete story
get '/mystories/delete/story/:storyId' do | storyId |
  p params
  if params["mode"] == "soft" then
    delete_soft_story storyId
  elsif params["mode"] == "hard" then
    delete_hard_story storyId
  end
  redirect '/mystories'
end

# story wizard
get '/mystories/wizard/:storyId/:tagId/:optionId' do | storyId, tagId, optionId |
  story = get_current_story storyId
  p story["tags"][tagId]["options"][optionId.to_i]
  haml :wizard_tag_option, :locals => {
    :params => story["tags"][tagId]["options"][optionId.to_i],
    :storyId => storyId,
    :tagId => tagId,
    :optionId => optionId,
    :tags => story["tags"]}
end

post '/mystories/wizard/:storyId/:tagId/:optionId' do | storyId, tagId, optionId |
  if params.has_key? "save" then
    save_option_from_params optionId.to_i, tagId, storyId, params
    redirect '/mystories/wizard/' + storyId + '/' + tagId + '/' + optionId
  elsif params.has_key? "add_option" then
    optionId = add_option tagId, storyId
    redirect '/mystories/wizard/' + storyId + '/' + tagId + '/' + optionId.to_s
  elsif params.has_key? "delete_option" then
    remove_option optionId.to_i, tagId, storyId
    redirect '/mystories/wizard/' + storyId + '/' + tagId    
  end
  redirect '/mystories/wizard/' + storyId + '/' + tagId + '/' + optionId
end

get '/mystories/wizard/:storyId/overview' do | storyId |
  haml :wizard_story_overview, :locals => {
    :params => get_current_story(storyId),
    :storyId => storyId
  }
end

get '/mystories/wizard/:storyId/:tagId' do | storyId, tagId |
  story = get_current_story storyId
  haml :wizard_tag, :locals => {
    :params => story["tags"][tagId],
    :storyId => storyId,
    :tagId => tagId,
    :tags => story["tags"]}
end

post '/mystories/wizard/:storyId/:tagId' do | storyId, tagId |
  if params.has_key? "save" then
    save_tag_from_params tagId, storyId, params
    redirect '/mystories/wizard/' + storyId + '/' + tagId
  elsif params.has_key? "add_option" then
    optionId = add_option tagId, storyId
    redirect '/mystories/wizard/' + storyId + '/' + tagId + '/' + optionId.to_s
  elsif params.has_key? "add_tag" then
    tagId = SecureRandom.uuid
    add_tag tagId, storyId
    redirect '/mystories/wizard/' + storyId + '/' + tagId
  elsif params.has_key? "delete_tag" then
    remove_tag tagId, storyId
    redirect '/mystories/wizard/' + storyId
  end
  redirect '/mystories/wizard/' + storyId + '/' + tagId
end

get '/mystories/wizard/:storyId' do | storyId |
  haml :wizard_story, :locals => {
    :params => get_current_story(storyId),
    :storyId => storyId
  }
end

post '/mystories/wizard/:storyId' do | storyId |
  if params.has_key? "save" then
    save_story_from_params storyId, params
    redirect '/mystories/wizard/' + storyId
  elsif params.has_key? "add_tag" then
    tagId = SecureRandom.uuid
    add_tag tagId, storyId
    redirect '/mystories/wizard/' + storyId + '/' + tagId
  end
  
  redirect '/mystories/wizard/' + storyId
end

# my stories
get '/mystories' do
  haml :mystories, :locals => { :stories => get_non_deleted_user_stories }
end

# other
get '/stories' do
  haml :stories, :locals => { :stories => get_stories }
end

# api
get '/api/stories/json' do
  content_type :json, 'charset' => 'utf-8'
  get_stories.to_json
end

get '/api/story/:id/json' do | id |
  content_type :json, 'charset' => 'utf-8'
  story = get_story_json(id)["story"]
  story.delete "editors"
  story.to_json
end

get '/api/statistic/:id/json' do | id |
  content_type :json, 'charset' => 'utf-8'
  user = validate_user id, params["refresh_token"]
  if user then
    get_statistic(user["id"]).to_json
  else
    '{"error": "We can\'t find that user"}'.to_json
  end
end

# sign in
get '/auth/:provider/callback' do
  content_type 'text/plain'
  begin
    log_in_user request.env['omniauth.auth']
  rescue => e
    puts "User was not logged in with request #{request.env}"
    puts e
  end
  redirect '/'
end

get '/auth/failure' do
  content_type 'text/plain'
  begin
    request.env['omniauth.auth'].to_hash.inspect
  rescue => e
    puts "User could not log in with request #{request.env}"
    puts e
  end
  redirect '/'
end
