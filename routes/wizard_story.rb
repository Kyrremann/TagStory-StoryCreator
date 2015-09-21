class TagStoryApp < Sinatra::Application
  get '/wizard/story' do
    @story = Story.find(params[:sid])
    haml :'wizard/story'
  end

  post '/wizard/story' do
    @story = Story.find(params[:sid])
    if @story.update(params[:story])
      redirect "wizard/story?sid=#{params[:sid]}"
    else
      haml :'wizard/story'
    end
  end
end
