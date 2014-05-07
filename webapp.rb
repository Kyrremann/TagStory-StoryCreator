require 'rubygems'
require 'sinatra'
require 'haml'
require 'json'

require_relative 'lib/story.rb'

$story = {}

get '/' do
  haml :index
end

get '/create/story' do
  p $story
  # load params from session
  haml :createStory, :locals => {:params => $story}
end

post '/create/story' do
  # save params to session
  # $story = $story.merge(params)
  # $story = params
  p "Posts"
  p params
  p $story
  $story.merge!(params)
  p $story
  if params[:addTag] then
    redirect '/create/tag'
  else
    haml :createStory, :locals => {:params => $story}
  end
end

get '/create/tag' do
  # load params from session
  haml :createTag, :locals => {:params => params}
end

post '/create/tag' do
  # save params to session
  # save tag
  if params[:story] then
    # $story = params
    redirect '/create/story'
  elsif params[:previous_tag] then
    # go to previous
  elsif params[:previous_tag] then
    # new tag
  else
    haml :createTag, :locals => {:params => params}
  end
end
