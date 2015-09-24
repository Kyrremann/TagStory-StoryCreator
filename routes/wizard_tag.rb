class TagStoryApp < Sinatra::Application
  get '/wizard/tag' do
    haml :'wizard/tag'
  end

  post '/wizard/tag' do
    if params[:content]
      content = params[:content]
      case content
      when 'top'
        filename = upload_image(@tag.story_id, content['top'])
        @tag.image_top = filename
      when 'middle'
        filename = upload_image(@tag.story_id, content['middle'])
        @tag.image_middle = filename
      when 'bottom'
        filename = upload_image(@tag.story_id, content['bottom'])
        @tag.image_bottom = filename
      end
    end

    if @tag.update(params[:tag])
      redirect "wizard/tag?sid=#{@tag.story_id}&tid=#{@tag.id}"
    else
      haml :'wizard/tag'
    end
  end

  get '/wizard/travel-option' do
    haml :'wizard/travel_option'
  end

  get '/wizard/tag/image-delete' do
    case params[:image]
    when 'top'
      @tag.image_top = nil
    when 'middle'
      @tag.image_middle = nil
    when 'bottom'
      @tag.image_bottom = nil
    end
    @tag.save
    redirect "wizard/tag?sid=#{@tag.story_id}&tid=#{@tag.id}"
  end
end
