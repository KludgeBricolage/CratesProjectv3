class UsersController < ApplicationController
  
  include UsersHelper::ForController
    
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  before_action :check_status, only: :show
  before_action :check_auth, only: :index
  #before_action :admin_user, only: :destroy
    
 
  def index
    @users = User.all
  end
    
  def show
      @user = User.find(params[:id])
      @report = Report.new
      if (params.has_key?(:rated_point) && params.has_key?(:id))
        current_user.user_ratings.new(rating_id: params[:rated_point],rated_person: params[:id]).save unless is_rated?(params[:id])
      end
      @act_crates =  Crate.where(["user_id = ? and active_status_id = ?", @user.id , 1])
  end
    
  def unrate
      @user = User.find_by(id: params[:id])
      if UserRating.where(user_id: current_user.id, rated_person: @user.id)
      UserRating.where(user_id: current_user.id, rated_person: @user.id).first.destroy
      else
      redirect_to @user, notice: 'Error'
      end
      redirect_to @user, notice: 'User unrated'
  end
    
  def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless  current_user?(@user)
  end
    
  def new
      @user = User.new
  end
    
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end
    
  def edit
    @user = User.find(params[:id])
  end
    
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
        @user.update_attributes(avatar: params[:user][:avatar]) unless params[:user][:avatar] == nil
        flash[:success] = 'Profile updated'
        redirect_to @user
    else
        render 'edit'
    end
  end
    
  def deactivate
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
      params.require(:user).permit(:alias, :email, :password,:password_confirmation) 
  end
  
  def check_status
      @user = User.find(params[:id])
      if @user.user_status_id > 1
          redirect_to root_url, notice: "User Account Inactivated."
      end
  end
    
  def change_status(asi_id,user)
      change_crates_asi(asi_id,user)
      user.update_attributes(user_status_id: asi_id)
  end
    
  def change_crates_asi(asi_id,user)
      Crate.where(user_id: user.id).update_all(active_status_id: asi_id)
  end    
    
    
end
