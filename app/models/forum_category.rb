class ForumCategory < ActiveRecord::Base
    extend FriendlyId
    friendly_id :name, use: :slugged
    has_many :forum_posts

end
