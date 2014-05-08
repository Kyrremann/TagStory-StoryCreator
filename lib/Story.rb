class Story
    attr_accessor :uuid, :author

    def initialize(uuid, author)
        @uuid = uuid
        @author = author
    end
end

def go 
	p "Go start"
	storyFile = '{"Resident":[{"UUID":"12345","author":"xxxxx"},{"UUID":"12345","author":"xxxxx"},{"UUID":"12345","author":"xxxxx"}]}'
	#storyFile = File.read("stories/0dd941f0-c943-11e2-8b8b-0800200c9a66.json")
	jsonStory = JSON.parse(storyFile)
	story_objects = jsonStory['Resident'].inject([]) { | object, data | 
		p data
		object << Story.new( 
			data['UUID'],
			data['author'] )}
	p story_objects[0].uuid
	p "Go end"
end
=begin
"12345"
"UUID":"story UUID",
	"author":"String",
	"title":"String",
	"genre":"String",
	"agegroup":"children|adult|family|teenager",
	"area":"String",
	"country":"String",
	"date":"created String",
	"description":"String",
	"image":"String",
	"keywords":"list",
	"url":"String",
	"startTag":"part UUID",
	"tagCount":"int",
	"language":"no_bm",
	"tagTypes":"nfc|qr|gps",
	"gameModes":"none|quiz",
=end