class TagStoryApp < Sinatra::Application
  get '/wizard/travel-option' do
    haml :'wizard/travel_option'
  end

  post '/wizard/travel-option' do
    if params[:content]
      content = params[:content]
      case content
      when 'top'
        filename = upload_image(@travel_option.story_id, content['top'])
        @travel_option.image_top = filename
      when 'middle'
        filename = upload_image(@travel_option.story_id, content['middle'])
        @travel_option.image_middle = filename
      when 'bottom'
        filename = upload_image(@travel_option.story_id, content['bottom'])
        @travel_option.image_bottom = filename
      end
    end

    if @travel_option.update(params[:travel_option])
      redirect "wizard/travel-option?sid=#{@tag.story_id}&tid=#{@tag.id}&toid=#{@travel_option.id}"
    else
      haml :'wizard/travel-option'
    end
  end


  get '/wizard/travel-option/image-delete' do
    case params[:image]
    when 'top'
      @travel_option.image_top = nil
    when 'middle'
      @travel_option.image_middle = nil
    when 'bottom'
      @travel_option.image_bottom = nil
    end
    @travel_option.save
    redirect "wizard/travel_option?sid=#{@tag.story_id}&tid=#{@tag.id}&toid=#{@travel_option.id}"
  end
end
