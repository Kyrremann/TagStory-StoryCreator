class TravelOption < ActiveRecord::Base
  belongs_to :tag

  validates_presence_of :title
end
