class Report < ActiveRecord::Base

    
    
    def set_user!(user)
        self.reporter = user.id
        self.save
    end
    
end
