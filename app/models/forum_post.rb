class ForumPost < ActiveRecord::Base
    extend FriendlyId
    friendly_id :title, use: :slugged        
    belongs_to :user
    has_one :forum_category
    has_many :subscriptions, dependent: :destroy
    has_many :forum_comments, dependent: :destroy
    scope :by_pin, -> { order('is_pin IS false') }
    scope :by_last_comment, -> { order(updated_at: :desc) }
    
    
    validates :title, presence: true, length: {maximum: 20}
    validates :description, presence: true, length: {maximum: 500}
    
    
end
