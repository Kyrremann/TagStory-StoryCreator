class TagStoryApp < Sinatra::Application
  get '/wizard/story' do
    @story = Story.find(params[:sid])
    haml :'wizard/story'
  end

  post '/wizard/story' do
    @story = Story.find(params[:sid])
    if @story.update(params[:story])
      redirect "wizard/story?sid=#{@story.id}"
    else
      haml :'wizard/story'
    end
  end

  get '/wizard/action' do
    @story = Story.find(params[:sid]) if params.has_key?('sid')
    @tag = Tag.find(params[:tid]) if params.has_key?('tid')

    case params[:action]
    when "add_tag"
      @tag = Tag.create(:story_id => @story.id,
                        :title => "New tag",
                        :description => "A simple description",
                        :tag_type => "qr")
      @tag.save
      redirect "wizard/tag?sid=#{@story.id}&tid=#{@tag.id}"
    when "add_travel_option"
      @travel_option = Travel_option.create(:tag_id => @tag.id,
                                             :title => "New travel option",
                                             :next_tag => 0)
      @travel_option.save
      redirect "wizard/travel-option?sid=#{@story.id}&tid=#{@tag.id}&toid=#{@travel_option.id}"
    end
  end
end
