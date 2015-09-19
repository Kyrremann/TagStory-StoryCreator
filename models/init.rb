require 'pg'

db_url = ENV['DATABASE_URL'] || 'postgres://postgres:postgres@localhost/tagstory'
db = URI.parse(db_url)

ActiveRecord::Base.establish_connection(
  :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
  :host     => db.host,
  :username => db.user,
  :password => db.password,
  :database => db.path[1..-1],
  :encoding => 'utf8'
)

require_relative 'user'
require_relative 'story'
require_relative 'tag'
require_relative 'travel_option'
require_relative 'game_option'
require_relative 'image'
require_relative 'authorgroup'
