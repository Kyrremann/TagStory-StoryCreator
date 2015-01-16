require_relative 'StoryHandler.rb'
require_relative 'TagHandler.rb'

def allow_url()
  ['/', '/stories', '/stories/json', '/help', '/auth', '/oauth2callback'].include?(request.path_info)\
  || ((request.path_info =~ /\/story\/[A-Za-z0-9]+/) == 0)\
  || ((request.path_info =~ /\/story\/[A-Za-z0-9]+\/json/) == 0)
end

def get_rev()
  session[:rev]
end

def set_rev(id)
  session[:rev] = id
end

# User
def get_user()
  session[:user_info]
end

def get_name()
  get_user["name"]
end

def get_given_name()
  get_user["given_name"]
end

def get_picture()
  get_user["picture"]
end

def has_access_token?()
  session[:access_token]
end
