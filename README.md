# StoryCreator

A story creator interface written in Ruby and Haml, using Sinatra and Heroku

The intention of this software is to help authors in the making of stories for TagStory

# TODO
* Ruby
  * Security - Need to avoid other users deleting your story
    * Implement some sort of version control (CLI diff?)
  * /create/ url's should just be used for creating a new of something, not for showing or editing tags or stories
  * Auth callback should not redirect to '/', but from where the call was made
* Views
  * Add functionality for preselecting of select-html-tag
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