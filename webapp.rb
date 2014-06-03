require 'rubygems'
require 'sinatra'
require 'haml'
require 'json'
require 'uuid'
require 'securerandom'

require_relative 'lib/Story.rb'
require_relative 'lib/SessionHandler.rb'

# enable :sessions
use Rack::Session::Cookie, :secret => 'super_secret_key_that_should_be_an_env_variable'

# Scopes are space separated strings
SCOPES = [
          'https://www.googleapis.com/auth/userinfo.email'
         ].join(' https://www.googleapis.com/auth/userinfo.profile')

unless G_API_CLIENT = ENV['G_API_CLIENT']
  raise "You must specify the G_API_CLIENT env variable"
end

unless G_API_SECRET = ENV['G_API_SECRET']
  raise "You must specify the G_API_SECRET env variable"
end

unless CLOUDANT_URL = ENV['CLOUDANT_URL']
  raise "You must specify the CLOUDANT_URL env variable"
end

def client
  client ||= OAuth2::Client.new(G_API_CLIENT, G_API_SECRET, {
                                  :site => 'https://accounts.google.com', 
                                  :authorize_url => "/o/oauth2/auth", 
                                  :token_url => "/o/oauth2/token"
                                })
end

before do
  unless ['/', '/stories', '/help', '/auth', '/oauth2callback'].include?(request.path_info)
    unless session[:access_token]
      redirect "/auth"
    end
  end
end

get '/' do
  haml :index
end

get "/auth" do
  redirect client.auth_code.authorize_url(:redirect_uri => redirect_uri,:scope => SCOPES,:access_type => "offline")
end

get '/oauth2callback' do
  access_token = client.auth_code.get_token(params[:code], :redirect_uri => redirect_uri)
  session[:access_token] = access_token.token
  p "Successfully authenticated with the server"
  
  # parsed is a handy method on an OAuth2::Response object that will 
  # intelligently try and parse the response.body
  session[:user_info] = access_token.get('https://www.googleapis.com/oauth2/v1/userinfo?alt=json').parsed
  redirect '/mystories'
end

get '/help' do
  haml :help
end

get '/community' do
  status 404
  body "Not implemented yet"
end

DB = "#{ENV['CLOUDANT_URL']}"
get '/stories' do
  # https://tagstory.cloudant.com/dashboard.html#database/stories/_design/lists/_view/story_header
  @doc = RestClient.get("#{DB}/stories/_design/lists/_view/story_header")
  @result = JSON.parse(@doc)
  haml :stories
end

get '/story/:id' do | id |
  @doc = RestClient.get("#{DB}/stories/#{id}")
  # https://tagstory.cloudant.com/stories/<uri> ex. => c1f1de345efe6e01c037feb3251b5e13
  # haml :createStory, :locals => {:params => get_story}
  @story = JSON.parse(@doc)["story"]
  haml :story
end

get '/mystories' do
  # https://[username].cloudant.com/animaldb/_design/views101/_search/animals?q=kookaburra
  @doc = RestClient.get("#{DB}/stories/_design/lists/_search/authors?q=K*")
  @result = JSON.parse(@doc)
  haml :my_stories
end

get '/mystories/create/story' do
  init_story
  redirect 'mystories/edit/story'
end

get '/mystories/create/tag' do
  init_tag
  redirect '/mystories/edit/tag'
end

get '/mystories/edit/tag/quiz' do
  haml :quiz, :locals => {:params => get_quiz}
end

post '/mystories/edit/tag/quiz' do
  save_quiz(params[:quiz])
  if params[:add_quiz] then
    add_question
  end
  redirect '/mystories/edit/tag/quiz'
end

get '/mystories/edit/tag/options' do
  haml :options, :locals => {:params => get_options}
end

post '/mystories/edit/tag/options' do
  save_options(params[:options])
  if params[:add_option] then
    add_option
  end
    
  redirect '/mystories/edit/tag/options'
end

get '/mystories/edit/tag/options/delete/:id' do
    delete_option(params[:id])
    redirect '/mystories/edit/tag/options'
end

get '/mystories/edit/tag/:id' do | id |
  unless is_a_tag_id(id.to_i) then
    status 404
    body "Can't find tag with id #{id}"
  else
    p id
    p get_current_tag
    switch_to_tag!(id.to_s)
    p get_current_tag
    redirect '/mystories/edit/tag'
  end
end

get '/mystories/edit/tag' do
  haml :edit_tag, :locals => {:params => get_current_tag}
end

post '/mystories/edit/tag' do
  merge_current_tag!(params)
  if params[:story] then
    redirect '/mystories/edit/story'
  elsif params[:add_tag] then
    redirect '/mystories/create/tag'
  else
    haml :edit_tag, :locals => {:params => get_current_tag}
  end
end

get '/mystories/edit/story/:id' do | id |
  if not is_a_story_id(id.to_i) then
    status 404
    body "Can't find story with id #{id}"
  else
    # switch_to_story(id.to_i)
    @doc = RestClient.get("#{DB}/stories/#{id}")
    @story = JSON.parse(@doc)["story"]
    # init_story
    # merge_story!(@story)
    # switch_to_tag!(1)
    load_story(id, @story)
    p get_story
    redirect '/mystories/edit/story'
  end
end

get '/mystories/edit/story' do
  haml :edit_story, :locals => {:params => get_story}
end

post '/mystories/edit/story' do
  merge_story!(params)
  if params[:add_tag] then
    redirect '/mystories/create/tag'
  else
    haml :edit_story, :locals => {:params => get_story}
  end
end

def redirect_uri
  uri = URI.parse(request.url)
  uri.path = '/oauth2callback'
  uri.query = nil
  uri.to_s
end

def is_active_url(url)
  "active" if url.kind_of?(String) and request.path_info.eql? url\
  or url.kind_of?(Array) and url.include? request.path_info
end
