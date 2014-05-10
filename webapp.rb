require 'rubygems'
require 'sinatra'
require 'haml'
require 'json'

require_relative 'lib/Story.rb'
require_relative 'lib/SessionHandler.rb'

enable :sessions

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
  redirect '/'
end

get '/stories' do
  haml :stories
end

get '/help' do
  haml :help
end

get '/story' do
  haml :createStory, :locals => {:params => get_story}
end

get '/create/story' do
  haml :createStory, :locals => {:params => init_story}
end

post '/create/story' do
  merge_story!(params)
  if params[:addTag] then
  	add_and_show_new_tag
  else
    haml :createStory, :locals => {:params => get_story}
  end
end

get '/tag/:id' do | id |
  unless is_a_tag_id(id.to_i) then
    status 404
    body "Can't find tag with id #{id}"
  else
    switch_to_tag!(id.to_i)
    redirect '/create/tag'
  end
end

get '/tag/:id/quiz' do | id |
  unless is_a_tag_id(id.to_i) then
    status 404
    body "Can't find tag with id #{id}"
  else
    switch_to_tag!(id.to_i)
    haml :quiz
  end
end

get '/tag/:id/options' do | id |
  unless is_a_tag_id(id.to_i) then
    status 404
    body "Can't find tag with id #{id}"
  else
    switch_to_tag!(id.to_i)
    haml :options
  end
end

get '/create/tag' do
  haml :createTag, :locals => {:params => get_current_tag}
end

post '/create/tag' do
  merge_current_tag!(params)
  if params[:story] then
    redirect '/create/story'
  elsif params[:add_tag] then
    add_and_show_new_tag
  else
    haml :createTag, :locals => {:params => get_current_tag}
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
