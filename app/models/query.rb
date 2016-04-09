class Query < ActiveRecord::Base
  include PublicActivity::Common  
  belongs_to :user
  belongs_to :crate
    
  has_many :replies, dependent: :destroy
  validates :title, presence:true, length:{maximum: 15}
  validates :description, presence:true, length:{maximum: 150}
    
    def set_user!(user)
        self.user_id = user.id
        self.save
    end
    
    
end
