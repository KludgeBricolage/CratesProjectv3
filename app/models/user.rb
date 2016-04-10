class User < ActiveRecord::Base
    #interruptors
    before_save :down_email
    before_create :create_activation_digest
    has_secure_password
    
    #groupify
    groupify :group_member
    
    #Relations
    has_many :user_ratings, dependent: :destroy
    has_many :crates, dependent: :destroy
    has_one :profile, dependent: :destroy
    has_one :user_status
    has_many :reportables
    has_many :reports, through: :reportables
    has_many :forum_posts
    has_many :forum_comments
    has_many :queries
    has_many :replies
    has_many :subscriptions, through: :forum_posts
    
    #avatar
    has_attached_file :avatar, styles: {
            :small => { :geometry => "100x100!" },
            :medium => { :geometry => "300x300!"} },
            default_url: "/images/:style/missing_:style.png",
            size: { in: 0..300.kilobytes }
    
    validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
    #Validation
    validates :password, presence: true, length: { minimum: 6 , maximum: 32}, allow_nil: true
    validates :email, presence:true, length:{maximum: 255}, uniqueness:{case_sensitive: false}
    validates :alias, presence:true, length:{maximum: 15}, uniqueness:{case_sensitive: true}
    
    #others
    default_scope {order('users.alias ASC')}
    attr_accessor :remember_token, :activation_token, :reset_token
    

    # Returns the hash digest of the given string.
    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                      BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end
    # Returns a random token.
    def User.new_token
        SecureRandom.urlsafe_base64
    end
    
    # Remembers a user in the database for use in persistent sessions.
    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end
    # Returns true if the given token matches the digest.
    def authenticated?(attribute, token)
        digest = send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
    end
    
    def forget
        update_attribute(:remember_digest, nil)
    end
    
    def activate
      update_attribute(:activated,    true)
      update_attribute(:activated_at, Time.zone.now)
    end
    
    def password_reset_expired?
        reset_sent_at < 2.hours.ago
    end

    
    def send_activation_email
      UserMailer.account_activation(self).deliver_now
    end
    
    def create_reset_digest
        self.reset_token = User.new_token
        update_attribute(:reset_digest,  User.digest(reset_token))
        update_attribute(:reset_sent_at, Time.zone.now)
    end
    
    # Sends password reset email.
    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end
    
    
    ################
    private
    def down_email
        self.email = email.downcase
    end
    
    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
    
    
end
