class Image < ActiveRecord::Base
  belongs_to :story
  belongs_to :tag
end
