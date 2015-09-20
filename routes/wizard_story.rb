class TagStoryApp < Sinatra::Application
  get '/wizard/story' do
    @story = Story.find(params[:sid])
    unless @story
      redirect '/'
    end

    haml :'wizard/story'
  end
end
