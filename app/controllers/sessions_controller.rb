class SessionsController < ApplicationController
    before_action :check_user, only: [:create,:new]
    
    def new
        
    end
    
    def check_user
        if current_user != nil
            message = "You are already logged in."
            flash[:message] = message
            redirect_to root_url
        end
    end
    
  def create
      user = User.find_by(email: params[:session][:email].downcase)
      if user && user.authenticate(params[:session][:password])
          if user.activated?
              if user_status_enab(user)
                message = "Your Account appears to be disabled"
                flash[:warning] = message   
                redirect_to root_url
              else
                reset_session
                log_in user
                params[:session][:remember_me] == '1' ? remember(user) : forget(user)
                if user.profile.nil?
                    redirect_to new_user_profile_url(user.id)
                else
                    redirect_back_or root_url
                end
              end
          else
            message  = 'Account not activated.'
            message += "Check your email for the activation link."
            flash[:warning] = message   
            redirect_to root_url
          end
        else
          # Create an error message.
          flash.now[:danger] = 'Invalid email/password combination' # Not quite right!
          render 'new'
      end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end 
    
  private 
    def user_status_enab(user)
        user.user_status_id != 1
    end
        
  
    
end
