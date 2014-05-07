require 'rubygems'
require 'sinatra'
require 'haml'
require 'json'

require_relative 'lib/story.rb'

$story = {}

get '/' do
  haml :index
end

get '/story/create' do
  haml :createStory
end

post '/story/create' do
	# save params to session
	if params[:addTag] then
		$story = params
		redirect '/story/create/tag'
	else
		haml :createStory, :local => {:params => params}
	end
end

get '/story/create/tag' do
	# load params from session
	haml :createTag, :local => {:params => params}
end

post '/story/create/tag' do
	# save params to session
	if params[:story] then
		# $story = params
		redirect '/story/create'
	else
		haml :createStory, :local => {:params => params}
	end
end

