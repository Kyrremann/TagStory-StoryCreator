class TagStoryApp < Sinatra::Application
  before '/my-stories*' do
    redirect '/' unless session[:id]
    if params[:sid]
      @story = Story.find(params[:sid])
    end
    redirect 'my-stories' if @story and not @story.has_owner(session[:id])
  end

  get '/my-stories' do
    user = User.find(session[:id])
    @stories = user.stories
    haml :'account/my_stories'
  end

  get '/my-stories/publish' do
    # TODO Validate the story and inform
    # @valid = @story.validate_for_publishing
    haml :'account/publish'
  end

  post '/my-stories/publish' do
    # check if valid
    @story.publish
    redirect 'my-stories'
  end

  get '/settings/profile' do
    haml :'account/profile'
  end
end
