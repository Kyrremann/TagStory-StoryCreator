require 'rubygems'
require 'sinatra'
require 'haml'
require 'json'

require_relative 'lib/story.rb'

get '/' do
  haml :index
end

get '/story/create' do
  haml :createStory
end

post '/story/create' do
  p params
  haml :createStory, :local => {:params => params}
end
