class Report < ActiveRecord::Base

        def set_user!(user)
        self.reporter_id = user.id
        self.save
    end
    
end
