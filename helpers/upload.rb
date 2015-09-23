module UploadHelper
  def upload_image(story_id, file)
    ending = file[:filename].split('.')[1]
    filename = "#{story_id}/images/#{SecureRandom.uuid}.#{ending}"
    value = $transloadit.assembly(
                                  :template_id => 'e99b5ba0247311e5bf2fdba7cf9f38b9',
                                  :fields => {
                                    :name => filename
                                  })#.submit! open(file[:tempfile])
    filename
  end

  def upload_audio(story_id, file)
    ending = file[:filename].split('.')[1]
    filename = story_id + '/audio/' + SecureRandom.uuid + '.' + ending
    value = $transloadit.assembly(
                                  :template_id => 'a5fc43102d7311e58b40f33e81f58d28',
                                  :fields => {
                                    :name => filename
                                  }).submit! open(file[:tempfile])
    filename
  end
end
