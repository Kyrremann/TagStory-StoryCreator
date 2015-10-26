module CloudantHandler
  begin
    def publish_to_cloudant(story, data)
      if story.last_published_id
        publish_new_version(story, data)
      else # first time publishing
        publish_for_the_first_time(story, data)
      end
    rescue => e
      logger.error "Something went wrong while contacting Cloudant. Story was ##{story.id}"
      logger.error e.message
      logger.error e.response
      logger.error data
    end
  end

  private

  def publish_new_version(story, data, retries = 1)
    logger.info 'publish new'
    if retries < 0
      logger.error "Can't upload new version of story ##{story.id}. Giving up"
      return
    end

    rev = Publication.find(story.last_published_id).rev
    data["_rev"] = rev
    RestClient.put("#{CLOUDANT_URL}/story_market/#{story.id}",
                   data.to_json,
                   {
                     :content_type => 'application/json',
                     :accept => :json
                   }) { | response, request, result |
      case response.code
      when 201
        rev = JSON.parse(response)['rev']
        data.delete("_rev")
        save_uploaded_story(story, data.to_json, rev)
      when 409
        logger.error "Got a 409 when trying to republish story ##{story.id}"
        logger.error response
        update_story_publication(story)
        story.reload
        data["_rev"] = nil
        retries -= 1
        publish_new_version(story, data, retries)
      else
        response.return!(request, result)
      end
    }
  end

  def update_story_publication(story)
    response = JSON.parse(RestClient.get("#{CLOUDANT_URL}/story_market/#{story.id}"))
    rev = response['_rev']
    publication = Publication.find_by_rev(rev)
    if publication.nil?
      save_uploaded_story(story, response, rev, true)
    else
      story.last_published_id = publication.id
      unless story.save
        logger.error "Could not save story with id #{story.id}"
        logger.error story.errors.full_messages
      end
    end
  end

  def publish_for_the_first_time(story, data)
    response = JSON.parse(RestClient.post("#{CLOUDANT_URL}/story_market",
                                          data,
                                          {
                                            :content_type => 'application/json',
                                            :accept => :json
                                          }))
    if response["ok"]
      save_uploaded_story(story, data, response["rev"])
      return response
    else
      logger.error "Something when wrong when uploading ##{story.id} to Cloudant"
      logger.error response
      logger.error data
    end
  end

  def save_uploaded_story(story, data, rev, retrieved_by_409 = false)
    logger.info "Saving uploaded story ##{story.id}. Rev was #{rev}"
    publication = Publication.create(:story_id => story.id,
                                     :version => story.version,
                                     :json => data,
                                     :rev => rev,
                                     :retrieved_by_409 => retrieved_by_409)
    if publication.save
      if story.first_published_id.nil?
        story.first_published_id = publication.id
      end

      story.version = story.version.to_i + 1
      story.last_published_id = publication.id
      story.published = true
      unless story.save
        logger.error "Could not save story with id #{story.id}"
        logger.error story.errors.full_messages
      end
    else
      logger.error "Could not save publication for story #{story.id}"
      logger.error publication.errors.full_messages
    end
  end
end
