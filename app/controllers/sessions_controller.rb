class SessionsController < ApplicationController
    before_action :check_user, only: [:create,:new]

    def new

    end

    def check_user
      # check if logged in
      if current_user != nil
          message = "You are already logged in."
          flash[:message] = message
          redirect_to root_url
      end
    end


  def create_from_fb
    # facebook login session
    email = env['omniauth.auth']['info']['email']
    if email.nil? or email.empty?
        redirect_to '/auth/facebook?auth_type=rerequest&scope=email'
    else
        user = User.from_omniauth(env["omniauth.auth"])
              if user_status_enab(user)
                message = "Your Account appears to be disabled"
                flash[:warning] = message
                redirect_to root_url
              else
                reset_session
                log_in user
                if user.profile.nil?
                    redirect_to new_user_profile_url(user.id)
                else
                    redirect_back_or root_url
                end
               end
    end
  end

  def create
      # create session on login
      user = User.find_by(email: params[:session][:email].downcase)
      if user.provider != nil
      redirect_to login_path, notice: 'Invalid Login'
      elsif user && user.authenticate(params[:session][:password])
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
    # session end
    log_out if logged_in?
    redirect_to root_url
  end

  private
    def user_status_enab(user)
        user.user_status_id != 1
    end



end
