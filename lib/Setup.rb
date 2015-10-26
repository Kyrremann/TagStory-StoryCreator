require 'haml'
require 'tilt/haml'
require 'json'
require 'rest_client'
require 'uuid'
require 'securerandom'
require 'omniauth'
require 'omniauth-google-oauth2'
require 'uri'
require 'sinatra/cross_origin'
require 'aws-sdk'
require 'sinatra/activerecord'

require_relative 'AuthHandler.rb'
require_relative 'DatabaseHandler.rb'
require_relative 'PostgresHandler.rb'
require_relative 'StoryHandler.rb'
require_relative 'UserHandler.rb'
require_relative 'Utils.rb'

use Rack::Session::Cookie, :secret => 'super_secret_key_that_should_be_an_env_variable' # TODO

# CloudAnt
unless CLOUDANT_URL = ENV['CLOUDANT_URL']
  raise "You must specify the CLOUDANT_URL env variable"
end

# Amazon S3
unless AWS_ACCESS_KEY_ID = ENV['AWS_ACCESS_KEY_ID']
  raise "You must specify the AWS_ACCESS_KEY_ID env variable"
end

unless AWS_SECRET_ACCESS_KEY = ENV['AWS_SECRET_ACCESS_KEY']
  raise "You must specify the AWS_SECRET_ACCESS_KEY env variable"
end

unless AWS_REGION = ENV['AWS_REGION']
  raise "You must specify the AWS_REGION env variable"
end

Aws.config.update({
                    region: AWS_REGION,
                    credentials: Aws::Credentials.new(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
                  })

# Google API
unless G_API_CLIENT = ENV['G_API_CLIENT']
  raise "You must specify the G_API_CLIENT env variable"
end

unless G_API_SECRET = ENV['G_API_SECRET']
  raise "You must specify the G_API_SECRET env variable"
end

SCOPES =
  'https://www.googleapis.com/auth/userinfo.email' +
  ' https://www.googleapis.com/auth/userinfo.profile'

use OmniAuth::Builder do
  provider :google_oauth2, G_API_CLIENT, G_API_SECRET, {
    :scope => "email, profile",
    :image_aspect_ratio => "square",
    :image_size => 100,
    :prompt => 'consent'
  }
end

before '/mystories/*' do
  unless logged_in?
    redirect '/'
  end
end

before '/api/*' do
  cross_origin
end
