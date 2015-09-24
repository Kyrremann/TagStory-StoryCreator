class Story < ActiveRecord::Base
  has_many :tags, :dependent => :destroy
  has_many :authorgroups
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
end
