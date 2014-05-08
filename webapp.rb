require 'rubygems'
require 'sinatra'
require 'haml'
require 'json'

require_relative 'lib/Story.rb'
require_relative 'lib/SessionHandler.rb'

$story = {:parts => {}}
$current_tag = 0

get '/' do
  haml :index
end

get '/stories' do
  haml :stories
end

get '/help' do
  haml :help
end

get '/create/story' do
  haml :createStory, :locals => {:params => get_story}
end

post '/create/story' do
  merge_story!(params)
  if params[:addTag] then
  	add_and_show_new_tag
  else
    haml :createStory, :locals => {:params => get_story}
  end
end

get '/create/tag/:id' do | id |
  p id
  switch_to_tag!(id.to_i)
  redirect '/create/tag'
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
