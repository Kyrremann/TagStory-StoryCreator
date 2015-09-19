class Tag < ActiveRecord::Base
  belongs_to :story
  has_many :travel_options
  has_many :images, foreign_key: 'belongs_to'
end
