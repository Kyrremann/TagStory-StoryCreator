class Tag < ActiveRecord::Base
  belongs_to :story
  has_many :travel_options
  has_many :images, foreign_key: 'belongs_to'

  validates_presence_of :title, :description
  validates :skippable, :endpoint, inclusion: { in: [true, false] }
  validates_inclusion_of :tag_type, in: %w{qr nfc gps}, message: "%{value} is not a valid tag type"
end
