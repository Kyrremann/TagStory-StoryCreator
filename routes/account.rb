class TagStoryApp < Sinatra::Application
  get '/my-stories' do
    user = User.find(session[:id])
    @stories = user.stories
    haml :'account/my_stories'
  end

  get '/settings/profile' do
    haml :'account/profile'
  end
end
