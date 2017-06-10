class UsersController < ApplicationController

  # Found in app/helpers
  include UsersHelper::ForController

  # These actions (functions) can be found at the bottom of the controller.
  # For best practices, these are private actions.
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  before_action :check_status, only: :show
  before_action :check_auth, only: :index
  #before_action :admin_user, only: :destroy

  def index
    # Get user list
    @users = User.all
  end

  def show
      # Find user
      @user = friendly_find(params[:id])
      # Instantiate report model for report form
      @report = Report.new
      # Get all active crates of found user
      @act_crates =  Crate.where(["user_id = ? and active_status_id = ?", @user.id , 1])
  end

  def unrate
      # 1) Find user
      @user = friendly_find(params[:id])
      # 2) Check if he is the current user
      if UserRating.where(user_id: current_user.id, rated_person: @user.id)
        UserRating.where(user_id: current_user.id, rated_person: @user.id).first.destroy
        redirect_to @user, notice: 'User unrated'
      else
        redirect_to @user, notice: 'Error'
      end
  end

  def rate
      # 1) Find user
      @user = friendly_find(params[:id])
      # 2) Check if he is the current user
      if params.has_key?(:rp)
        current_user.user_ratings.new(rating_id: params[:rp],rated_person: @user.id).save unless is_rated?(params[:id])
        redirect_to @user, notice: 'User rated'
      else
        redirect_to @user, notice: 'Error'
      end
  end


  def correct_user
      @user = friendly_find(params[:id])
      redirect_to(root_url) unless  current_user?(@user)
  end

  def new
      @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # Send activation email
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = friendly_find(params[:id])
  end

  def update
    # Update user based on post parameters
    @user = friendly_find(params[:id])
    if @user.update_attributes(user_params)
      # Check if there is an avatar parameter
      @user.update_attributes(avatar: params[:user][:avatar]) unless params[:user][:avatar] == nil
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def deactivate
    # Deactivate account
    change_status(2,current_user)
    log_out
    redirect_to root_url
  end

  def activate
      #change_status(2,current_user)
      #log_out
      #redirect_to root_url
  end


  private
  def user_params
      params.require(:user).permit(:alias, :email, :password,:password_confirmation, :slug)
  end

  def check_status
      @user = friendly_find(params[:id])
      if @user.user_status_id > 1
          redirect_to root_url, notice: "User Account Inactivated."
      end
  end

  def change_status(asi_id,user)
      # Change user status
      change_crates_asi(asi_id,user)
      user.update_attributes(user_status_id: asi_id)
  end

  def change_crates_asi(asi_id,user)
      # Change all Crates of user depending on user status
      Crate.where(user_id: user.id).update_all(active_status_id: asi_id)
  end

  def friendly_find(id)
      # read friendly_id gem
      User.friendly.find(id)
  end

end
