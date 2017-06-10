class ProfilesController < ApplicationController
    # Error catching
    rescue_from ::ActiveRecord::RecordNotFound, with: :dont_url_manipulate
    rescue_from ::ActiveRecord::InvalidForeignKey, with: :dont_url_manipulate

    # These actions (functions) can be found at the bottom of the controller.
    # For best practices, these are private actions.
    before_action :logged_in_user, only: [:new,:create,:edit,:update]
    before_action :correct_user,   only: [:new,:create,:edit,:update]
    before_action :check_profile, only: [:new,:create]

    #redirect to root if profile already exist
    def check_profile
        @user = User.find(params[:user_id])
        redirect_to root_url if !@user.profile.nil?
    end

    def correct_user
      @user = User.find(params[:user_id])
      redirect_to(root_url) unless  current_user?(@user)
    end

    # These actions (functions) are the basic CRUD

    def new
        @user = User.find(params[:user_id])
        @profile = @user.build_profile
    end

    def show
        @user = User.find(params[:user_id])
        @profile = @user.profile
    end

    def create
        @user = User.find(params[:user_id])
        @profile = @user.build_profile(profile_params)
        if @profile.save
            flash[:success] = "Profile has been created"
            redirect_to root_url
        else
            render 'new'
        end
    end

    def edit
        @user = User.find(params[:user_id])
        @profile = @user.profile
    end

    def update
        @user = User.find(params[:user_id])
        if @user.profile.update_attributes(profile_params)
            flash[:success] = 'Profile updated'
            redirect_to @user
        else
            render 'edit'
        end
    end

    private
    def profile_params
        params.require(:profile).permit(:first_name,:last_name,:middle_name,:address,:phone_number,:birth_date,:gender)
    end

end
