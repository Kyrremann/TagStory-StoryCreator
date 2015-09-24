module UploadHelper
  def upload_image(story_id, file)
    ending = file[:filename].split('.')[1]
    filename = "#{SecureRandom.uuid}.#{ending}"
    path = "#{story_id}/images/#{filename}"
    value = $TRANSLOADIT.assembly(
                                  :template_id => 'e99b5ba0247311e5bf2fdba7cf9f38b9',
                                  :fields => {
                                    :name => path
                                  }).submit!(open(file[:tempfile]))
    filename
  end

  def upload_audio(story_id, file)
    ending = file[:filename].split('.')[1]
    filename = "#{SecureRandom.uuid}.#{ending}"
    path = "#{story_id}/audio/#{filename}"
    value = $TRANSLOADIT.assembly(
                                  :template_id => 'a5fc43102d7311e58b40f33e81f58d28',
                                  :fields => {
                                    :name => path
                                  }).submit!(open(file[:tempfile]))
    filename
  end
end
