require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require_relative 'config/app_config'

class TagStoryApp < Sinatra::Application

  configure :production do
    set :haml, { :ugly=>true }
    set :clean_trace, true
    enable :logging
  end

  configure :development do
    enable :logging
  end

  before do
    content_type :html, 'charset' => 'utf-8'
  end
end

require_relative 'models/init'
require_relative 'helpers/init'
require_relative 'routes/init'
