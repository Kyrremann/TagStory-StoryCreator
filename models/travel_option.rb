class TravelOption < ActiveRecord::Base
  belongs_to :tag

  validates_presence_of :title

  def to_market
    {
      "method" => self.method,
      "answer" => self.answer,
      "title" => self.title,
      "text" => self.help_text,
      "next" => self.next_tag,
      "zoom_level" => self.map_zoom_level,
      "gps_radius" => self.gps_radius,
      "lat" => self.gps_latitude,
      "long" => self.gps_longitude
    }
  end
end
