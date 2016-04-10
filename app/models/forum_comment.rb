class ForumComment < ActiveRecord::Base
  include PublicActivity::Common
  belongs_to :user
  belongs_to :forum_post
  validates :comment, presence: true, length: {maximum: 100}
  validates :user_id, presence: true
  validates :forum_post_id, presence: true  
  default_scope -> { order(created_at: :asc)}
    
end
