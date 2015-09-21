class Story < ActiveRecord::Base
  has_many :tags
  has_many :authorgroups
  has_many :user, through: :authorgroups
  has_many :images, foreign_key: 'belongs_to'

  # acts_as_taggable_on :genre, :keywords, :tag_types, :game_modes

  validates_presence_of :title, :description, :author, :country, :city, :place
  validates_inclusion_of :language, in: I18nData.languages, message: "%{value} is not a valid language"
  validates_associated :tags
end
