class Tag < ActiveRecord::Base
  belongs_to :story
  has_many :travel_options, :dependent => :destroy
  has_many :images, foreign_key: 'belongs_to', :dependent => :destroy

  validates_presence_of :title, :description
  validates :skippable, :endpoint, inclusion: { in: [true, false] }
  validates_inclusion_of :tag_type, in: %w{qr nfc gps}, message: "%{value} is not a valid tag type"

  def validate_for_publishing(errors)
    unless self.question.blank?
      self.travel_options.each do | option |
        if option.answer.blank?
          errors.add(:answer, "Missing answer of tags question")
        end
      end
    end
  end

  def to_market
    options = []
    self.travel_options.each do | option |
      options << option.to_market
    end

    {
      self.id => {
        "title" => self.title,
        "description" => self.description,
        "tag_image_top" => self.image_top,
        "tag_image_middle" => self.image_middle,
        "tag_image_bottom" => self.image_bottom,
        "question" => self.question,
        "travel_button" => self.travel_button,
        "skippable" => self.skippable,
        "isEndPoint" => self.endpoint,
        "tag_type" => self.tag_type,
        "game_mode" => self.game_mode,
        "options" => options
      }
    }
  end
end
