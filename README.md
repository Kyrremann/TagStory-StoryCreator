# StoryCreator

A story creator interface written in Ruby and Haml, using Sinatra and Heroku

The intention of this software is to help authors in the making of stories for TagStory

# TODO
* Ruby
  * Security - Need to avoid other users deleting your story
    * Implement some sort of version control (CLI diff?)
  * /create/ url's should just be used for creating a new of something, not for showing or editing tags or stories
  * Auth callback should not redirect to '/', but from where the call was made
  * Upload files to Amazon S3
    * See Amazon AWS S3 example
    * Use Transloadit.com for the transfer
    * Or use Paperclip https://devcenter.heroku.com/articles/paperclip-s3
* Views
  * Add a "My stories" section (instead of Create Story)
    * Showes stories you have made, and stories you are working on
    * Let you create or delete stories
  * Add a table of stories
  * Implement logic for checkboxes

# Links
* Gems
  * Pony for simple e-mail
    * http://rubygems.org/gems/pony
  * Error-handling
    * http://myronmars.to/n/dev-blog/2012/01/why-sinatras-halt-is-awesome
  * UUID
    * http://rubydoc.info/gems/uuidtools/2.1.4/frames
    * or SecureRandom.uuid

# URL Hierarchy
/ - Frontpage
/help - Help
/community - Community/forum *
/auth - Log in
/oauth2callback - Callback after logging in, will redirect to /mystories
/logout - Log out *

/mystories - Users main site
/mystories/profile - A users profile *
/mystories/create/story - Create a new story
/mystories/create/tag - Create a new tag for current story
/mystories/edit/<id> - Edit a story with id and set to current story
/mystories/edit/tag/<id> - Edit a tag with id and set to current tag
/mystories/edit/tag/quiz - Edit current tag's quiz
/mystories/edit/tag/options - Edit current tag's options

/stories - List of (complete) stories for downloading
/story/<id> *
/story/<id>/tag/<id> *
/story/<id>/tag/<id>/quiz *
/story/<id>/tag/<id>/options *

/api/stories/ - Returns a JSON of avaiable stories *
/api/story/<id> - Returns the JSON for the story *

&#42; Means that it is not implemented and may change