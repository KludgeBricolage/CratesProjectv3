class Crate < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
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
    
  default_scope -> { order(created_at: :desc)}
  validate  :validate_tags
  validate  :validate_pictures
  validates :user_id, presence: true
  validates :name, presence: true, length: {minimum: 3,maximum: 30}
  validates :description, presence: true, length: {maximum: 300}
  validates :states_id,presence: true, :numericality => {:greater_than => 0, :less_than =>3}
  validates :price, presence: true, :numericality => {:greater_than => 0, :less_than =>1000000000}
    
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

end
