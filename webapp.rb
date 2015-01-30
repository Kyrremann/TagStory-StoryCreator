require 'rubygems'
require 'sinatra'
require 'haml'
require 'json'
require 'uuid'
require 'securerandom'

use Rack::Session::Cookie, :secret => 'super_secret_key_that_should_be_an_env_variable'

unless CLOUDANT_URL = ENV['CLOUDANT_URL']
  raise "You must specify the CLOUDANT_URL env variable"
end

DB = "#{ENV['CLOUDANT_URL']}"

before do
  content_type :html, 'charset' => 'utf-8'
end

get '/' do
  haml :index
end

get '/login' do
  "not implemented"
end

# new story
get '/mystories/wizard/story' do
  haml :wizard_story
end

post '/mystories/wizard/story' do
  p params
  if params["add_tag"] then
    redirect '/mystories/wizard/story/tag'
  else
    redirect '/mystories/wizard/story'
  end
end

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

# edit story
get '/mystories/edit/story/:storyId/:tagId/:optionId' do | storyId, tagId, optionId |
  @doc = RestClient.get("#{DB}/stories/#{storyId}")
  @result = JSON.parse(@doc)
  haml :wizard_tag_option, :locals => {
    :params => @result["story"]["tags"][tagId]["options"][optionId],
    :storyId => storyId,
    :tagId => tagId,
    :optionId => optionId,
    :tags => @result["story"]["tags"]
  }
end

get '/mystories/edit/story/:storyId/:tagId' do | storyId, tagId |
  @doc = RestClient.get("#{DB}/stories/#{storyId}")
  @result = JSON.parse(@doc)
  haml :wizard_tag, :locals => {
    :params => @result["story"]["tags"][tagId],
    :storyId => storyId,
    :tagId => tagId,
    :tags => @result["story"]["tags"]}
end

get '/mystories/edit/story/:storyId' do | storyId |
  @doc = RestClient.get("#{DB}/stories/#{storyId}")
  @result = JSON.parse(@doc)
  haml :wizard_story, :locals => {
    :params => @result["story"],
    :storyId => storyId
  }
end


get '/stories' do
  @doc = RestClient.get("#{DB}/stories/_design/lists/_view/story_header")
  @result = JSON.parse(@doc)["rows"]
  haml :stories
end

get '/stories/json' do
  @doc = RestClient.get("#{DB}/stories/_design/lists/_view/story_header")
  @result = JSON.parse(@doc)
  content_type :json, 'charset' => 'utf-8'
  @result["rows"].to_json
end

get '/story/:id/json' do | id |
  @doc = RestClient.get("#{DB}/stories/#{id}")
  @result = JSON.parse(@doc)
  content_type :json, 'charset' => 'utf-8'
  @result.to_json
end
