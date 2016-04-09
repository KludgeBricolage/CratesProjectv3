class Subscription < ActiveRecord::Base
    
    belongs_to :user
    belongs_to :forum_post
    
    validates :user_id, presence: true
    validates :forum_post_id, presence: true
    
    def set_user!(user)
        self.user = user
        self.save
    end
    
end
