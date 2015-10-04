class TagStoryApp < Sinatra::Application
  before '/wizard/*' do
    redirect '/' unless session[:id]
    if params[:sid]
      @story = Story.find(params[:sid])
    end

    if params[:tid]
      @tag = Tag.find(params[:tid])
      unless @story
        @story = Story.find(@tag.story_id)
      end
    end

    if params[:toid]
      @travel_option = TravelOption.find(params[:toid])
      unless @tag
        @tag = Tag.find(@travel_option.tag_id)
        unless @story
          @story = Story.find(@tag.story_id)
        end
      end
    end

    redirect '/my-stories' unless @story and @story.has_owner(session[:id])
  end

  get '/wizard/story' do
    haml :'wizard/story'
  end

  post '/wizard/story' do
    if params[:cover_image]
      url = upload_image(@story.id, params[:cover_image])
      if @story.images.empty?
        Image.create(:belongs_to => @story.id,
                     :url => url,
                     :owner => session[:id])
      else
        image = @story.images.first
        image.url = url
        image.save
      end
      @story.reload
    end
    if @story.update(params[:story])
      redirect "wizard/story?sid=#{@story.id}"
    else
      haml :'wizard/story'
    end
  end

  get '/wizard/action' do
    case params[:action]
    when "add_tag"
      @tag = Tag.create(:story_id => @story.id,
                        :title => "New tag",
                        :description => "A simple description",
                        :tag_type => "qr")
      @tag.save
      redirect "wizard/tag?sid=#{@story.id}&tid=#{@tag.id}"
    when "delete_tag"
      @tag.destroy
      redirect "wizard/story?sid=#{@story.id}"
    when "add_travel_option"
      @travel_option = TravelOption.create(:tag_id => @tag.id,
                                             :title => "New travel option",
                                             :next_tag => 0)
      if @travel_option.save
        redirect "wizard/travel-option?sid=#{@story.id}&tid=#{@tag.id}&toid=#{@travel_option.id}"
      else
        redirect "wizard/tag?sid=#{@story.id}&tid=#{@tag.id}"
      end
    when "delete_travel_option"
      @travel_option.destroy
      redirect "wizard/tag?sid=#{@story.id}&tid=#{@tag.id}"
    when "dup_travel_option"
      dup = @travel_option.dup
      if dup.save
        redirect "wizard/travel-option?sid=#{@story.id}&tid=#{@tag.id}&toid=#{@travel_option.id}"
      else
        redirect "wizard/tag?sid=#{@story.id}&tid=#{@tag.id}"
      end
    end

    redirect :"wizard/story?sid=#{@story.id}"
  end

  get '/wizard/story/qr-codes' do
    @length = params['length'] || 150
    if @length.to_i > 1000
      @error = 'Max size is 1000'
      @length = 150
    end
    haml :'wizard/qr-codes'
  end

  post '/wizard/story/qr-codes' do
    redirect "wizard/story/qr-codes?sid=#{@story.id}&length=#{params['length']}"
  end

  get '/wizard/story/overview' do
    @coords = []
    @story.tags.each do | tag |
      tag.travel_options.each do | travel_option |
        if travel_option.method == 'map'
          @coords << {
            'lat' => travel_option.gps_latitude,
            'long' => travel_option.gps_longitude
          }
        end
      end
    end
    haml :'wizard/overview'
  end
end
