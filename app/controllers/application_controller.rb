class ApplicationController < ActionController::Base
  #rescue_from ::ActiveRecord::RecordNotFound, with: :dont_url_manipulate
  #rescue_from ::ActiveRecord::InvalidForeignKey, with: :dont_url_manipulate

  protect_from_forgery with: :exception
  include SessionsHelper
  
    # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:error] = "Please log in."
      redirect_to login_url
    end
  end

  
  def check_auth
        logged_in_user
        unless is_admin?
            flash[:error] = "Invalid Action"
            redirect_to root_url
        end
  end    
    
  def dont_url_manipulate
      render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found
  end
    
  
    
end
