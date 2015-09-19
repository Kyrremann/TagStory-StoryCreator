use Rack::Session::Cookie, :secret => 'super_secret_key_that_should_be_an_env_variable' # TODO

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
    :scope => SCOPES, #"email, profile",
    :image_aspect_ratio => "square",
    :image_size => 100,
    :prompt => 'consent'
  }
end
