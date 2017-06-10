class Profile < ActiveRecord::Base
    # Associations
    belongs_to :user

    # Do these first before executing...
    before_save :fix_me
    before_update :fix_me

    # Validations
    validates :first_name, presence:true, length: {maximum: 50}
    validates :last_name, presence:true, length: {maximum: 50}
    validates :middle_name, presence:true, length: {maximum: 50}
    validates :phone_number, presence:true, length:{maximum: 20}
    validates :gender, presence:true
    validates :birth_date, presence:true

    # Method
    def fix_me
        self.first_name = first_name.downcase.capitalize
        self.middle_name = middle_name.downcase.capitalize
        self.last_name = last_name.downcase.capitalize
    end


end
