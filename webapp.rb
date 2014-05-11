require 'rubygems'
require 'sinatra'
require 'haml'
require 'json'

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
  raise "You must specify the G_API_SECRET env veriable"
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

get '/stories' do
  haml :stories
end

get '/story/:id' do
  # haml :createStory, :locals => {:params => get_story}
  redirect '/community'
end

get '/mystories' do
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
  haml :quiz
end

post '/mystories/edit/tag/quiz' do
  # save question
  if params[:add_quiz] then
    # a question
  end
  haml :quiz
end

get '/mystories/edit/tag/options' do
  haml :options
end

post '/mystories/edit/tag/options' do
  # save option
  haml :options
end

get '/mystories/edit/tag/:id' do | id |
  unless is_a_tag_id(id.to_i) then
    status 404
    body "Can't find tag with id #{id}"
  else
    switch_to_tag!(id.to_i)
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

get 'mystories/edit/story/:id' do
  unless is_a_story_id(id.to_i) then
    status 404
    body "Can't find story with id #{id}"
  else
    switch_to_story(id.to_i)
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
