class TagStoryApp < Sinatra::Application
  before '/market*' do
    if params[:sid]
      @story = Story.find(params[:sid])
      unless @story.published
        redirect '/market'
      end
    end
  end

  get '/market' do
    @stories = Story.where('published = ?', true).order('title DESC')
    haml :'market/market'
  end

  get '/market/story' do
    haml :'market/story'
  end
end
