class TagStoryApp < Sinatra::Application
  before '/my-stories*' do
    redirect '/' unless session[:id]
    @user = User.find(session[:id])

    if params[:sid]
      @story = Story.find(params[:sid])
    end
    redirect 'my-stories' if @story and not @story.has_owner(session[:id])
  end

  get '/my-stories' do
    @stories = @user.stories
    haml :'account/my_stories'
  end

  get '/my-stories/create' do
    @story = Story.create_dummy(@user)
    @story.save!
    @authorgroups = Authorgroup.new(:story_id =>  @story.id,
                                     :user_id => @user.id,
                                     :owner => true)
    if @authorgroups.save
      redirect "/wizard/story?sid=#{@story.id}"
    end
  end

  get '/my-stories/publish' do
    # TODO Validate the story and inform
    # @valid = @story.validate_for_publishing
    haml :'account/publish'
  end

  post '/my-stories/publish' do
    # check if valid
    publish_to_cloudant(@story, @story.publish)
    redirect 'my-stories'
  end

  get '/my-stories/unpublish' do
    # haml :'account/publish'
    'TODO'
  end

  get '/settings/profile' do
    haml :'account/profile'
  end
end
