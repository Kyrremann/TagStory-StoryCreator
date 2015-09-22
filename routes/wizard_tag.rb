class TagStoryApp < Sinatra::Application
  get '/wizard/tag' do
    @tag = Tag.find(params[:tid])
    @story = Story.find(params[:sid])
    haml :'wizard/tag'
  end

  post '/wizard/tag' do
    @tag = Tag.find(params[:tid])
    if @tag.update(params[:tag])
      redirect "wizard/tag?sid=#{@tag.story_id}&tid#{@tag.id}"
    else
      haml :'wizard/tag'
    end
  end

  post '/wizard/travel-option' do
    @travel_option = Travel_option.find(params[toid])
    @tag = Tag.find(params[:tid])
    @story = Story.find(params[:sid])
    haml :'wizard/travel_option'
  end
end
