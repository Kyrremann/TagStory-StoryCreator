module CloudantHandler  
  def publish_to_cloudant(story, data)
    begin
      @respons = JSON.parse(RestClient.post("#{CLOUDANT_URL}/story_market",
                                            data,
                                            {
                                              :content_type => 'application/json'
                                            }))
      if @respons["ok"]
        logger.info "Uploaded story ##{@story.id} to Cloudant. Rev was #{@respons["rev"]}"
        @publication = Publication.create(:story_id => @story.id,
                                          :version => @story.version,
                                          :json => data,
                                          :rev => @respons["rev"])
        if @publication.save
          unless @story.published
            @story.first_published_id = @publication.id
          end
          @story.version = @story.version.to_i + 1
          @story.last_published_id = @publication.id
          @story.published = true
          @story.save
        else
          logger.error "Could not save publication for story #{@story.id}"
        end

        return @respons
      else
        logger.error "Something when wrong when uploading ##{@story.id} to Cloudant"
        logger.error @respons
        logger.error data
      end
    rescue => e
      logger.error "Something went wrong while contacting Cloudant. Story was ##{@story.id}"
      logger.error e.message
      logger.error e.response
      logger.error data
    end
  end
end
