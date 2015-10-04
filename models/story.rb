class Story < ActiveRecord::Base
  has_many :tags, :dependent => :destroy
  has_many :publications, :dependent => :destroy
  has_many :authorgroups, :dependent => :destroy
  has_many :user, through: :authorgroups
  has_many :images, foreign_key: 'belongs_to', :dependent => :destroy

  # acts_as_taggable_on :genre, :keywords, :tag_types, :game_modes

  validates_presence_of :title, :description, :author, :country, :city, :place
  validates_inclusion_of :language, in: I18nData.languages, message: "%{value} is not a valid language"
  validates_associated :tags

  def has_owner(id)
    self.authorgroups.each do | group |
      return true if group.user_id == id
    end

    logger.warn "User #{id} tried to access story #{self.id}"
    return false
  end

  def self.create_dummy(user)
    Story.new(:title => 'Dummy story',
              :author => user.username,
              :description => 'This is a new story',
              :age_group => '',
              :language => 'EN',
              :country => 'Norway',
              :city => 'Oslo',
              :place => 'Tag Story HQ')
  end

  def validate_for_publishing
    if self.images.empty?
      self.errors.add(:images, "Missing story image")
    end

    have_endpoint = false
    have_several_endpoints = false
    self.tags.each do | tag |
      if tag.endpoint
        if have_last_tag
          have_several_endpoints = true
        else
          have_last_tag = true
        end
      end
      tag.validate_for_publishing
    end

    if have_several_endpoints
      self.errors.add(:endpoint, "Story has several endpoints")
    elsif not have_endpoint
      self.errors.add(:endpoint, "Story is missing a last tag")
    end
  end

  def publish
    to_market.to_json
  end

  def to_market
    tags = []
    self.tags.each do | tag |
      tags << tag.to_market
    end
    {
      "_id" => self.id,
      "author" => self.author,
      "title" => self.title,
      "description" => self.description,
      "image" => self.images.first,
      "status" => "published",
      "version" => self.version,
      "age_group" => self.age_group,
      "genre" => "TODO",
      "keywords" => "TODO",
      "language" => self.language,
      "country" => self.country,
      "city" => self.city,
      "place" => self.place,
      "estimated_time" => self.estimated_time,
      "url" => self.url,
      "tag_types" => "qr",
      "game_modes" => "none",
      "tags" => tags
    }
  end
end
