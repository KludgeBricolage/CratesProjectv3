class Crate < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  # Associations
  belongs_to :user
  has_one :category
  has_one :state
  has_one :quality
  has_one :active_status
  has_many :taggings ,:dependent => :destroy
  has_many :tags, :through => :taggings
  has_many :pictures, :dependent => :destroy
  has_many :queries, :dependent => :destroy
  has_one :location

  # Scopes
  default_scope -> { order(created_at: :desc)}

  # Validations
  validate  :validate_tags
  validate  :validate_pictures
  validates :user_id, presence: true
  validates :name, presence: true, length: {minimum: 3,maximum: 30}
  validates :description, presence: true, length: {maximum: 300}
  validates :states_id,presence: true, :numericality => {:greater_than => 0, :less_than =>3}
  validates :price, presence: true, :numericality => {:greater_than => 0, :less_than =>1000000000}

  # Actions
    def validate_tags
     errors.add(:tags, "Up to 5 Tags only") if tags.size > 5
    end

    def validate_pictures
        errors.add(:pictures, "You have reached the 5 image limit") if pictures.length > 4
    end

    def all_tags=(names)
        self.tags = names.split(",").map do |name|
            Tag.where(name: name.strip).first_or_create! unless name == ""
        end
    end

    def all_tags
        self.tags.map(&:name).join(", ")
    end

    def self.tagged_with(name)
        Tag.find_by_name!(name).crates
    end

  # This is used in the API
  # Decides which data will be exposed by the API endpoint
  # JSON format (hash)
  def to_hash
    data = {}

    data[:id] = self.id
    data[:user] = self.user.id
    data[:name] = self.name
    data[:description] = self.description
    data[:created_at] = self.created_at.strftime('%b %d %Y %I:%M%p')
    data[:states] = State.find(self.states_id).status
    data[:quality] = Quality.find(self.qualities_id).name
    data[:price] = self.price
    data[:category] = Category.find(self.category_id).name
    data[:tags] = []
    unless self.tags.count < 1
      self.tags.each do |tag|
        data[:tags] << tag.name
      end
    end

    data
  end

end
