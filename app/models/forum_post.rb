class ForumPost < ActiveRecord::Base
        
    belongs_to :user
    has_one :forum_category
    has_many :subscriptions, dependent: :destroy
    has_many :forum_comments, dependent: :destroy
    scope :by_last_comment, -> { order(updated_at: :desc) }
    scope :by_pin, -> { order('is_pin IS false') }
    
    validates :title, presence: true, length: {maximum: 20}
    validates :description, presence: true, length: {maximum: 500}
    
    def self.subscribers
        
    end
    
end
