class CratesController < ApplicationController

    # These actions (functions) can be found at the bottom of the controller.
    # For best practices, these are private actions.

    before_action :logged_in_user, only: [:create, :destroy, :edit]
    before_action :correct_crate,   only: [:destroy, :edit, :update]
    before_action :add_profile, only: [:new,:create]
    before_action :check_user_status, only: [:show]

    # Error catching
    rescue_from ::ActiveRecord::RecordNotFound, with: :dont_url_manipulate
    rescue_from ::ActiveRecord::InvalidForeignKey, with: :dont_url_manipulate

    def index
        # Ransack is a search Gem
        # Pagination done with Kaminari Gem
        @crates = Crate.where(:active_status_id => '1').page(params[:page]).per(12)
        @search = Crate.where(:active_status_id => '1').ransack(params[:q])
        if params.has_key?(:name)
            @crates = Crate.find_by(name:params[:name]).page(params[:page]).per(12)
        elsif params[:tag]
            @crates = Crate.tagged_with(params[:tag]).where(:active_status_id => '1').page(params[:page]).per(12)
        elsif params[:q]
            @crates = @search.result.page(params[:page]).per(12)
        end
    end

    def add_profile
        # User must create a profile first
        # Comment out the before_action to disable
        if current_user.profile.nil?
            flash[:success] = 'Create a Profile First'
            redirect_to new_user_profile_url(current_user.id)
        end
    end

    def new
      # Locations is for the Crate's preferred meet-up location
      # This is also important for the Mobile application
      @locations = Location.all
      @crate = current_user.crates.build if logged_in?
    end

    def create
        @crate = current_user.crates.build(crate_params)
        if @crate.save
            if params[:pictures]
              # :pictures parameter is an array, check the view's form
              # Iterate through the pictures to associate it with the crate
              params[:pictures].each { |image|
                @crate.pictures.create(image: image)
              }
            end
              flash[:success] = 'Crate has been posted!'
              redirect_to @crate
        else
            render new_crate_path
        end
    end

    def edit
        @crate = friendly_find(params[:id])
        @pics = @crate.pictures
    end

    def update
        @crate = friendly_find(params[:id])
        @pics = @crate.pictures
        if @crate.update_attributes(crate_params)
            if params[:pictures]
                params[:pictures].each { |image|
                 @crate.pictures.create(image: image)
                }
                flash[:success] = 'Crate has been posted!'
            end
            #successful edit
            flash[:success] = 'Crate updated'
            redirect_to @crate
        else
            render 'edit'
        end
    end

    def destroy
        @crate.destroy
        flash[:success] = "Crate deleted"
        redirect_to '/'
    end

    def show
        # This is the only database call
        @crate = friendly_find(params[:id])

        # These instance variables are declared in accordance to the Law of Demeter
        @images = @crate.pictures
        @contact = @crate.user.profile.phone_number
        @query = @crate.queries.build
        @queries = @crate.queries.all

        # Instantiate a new reply
        @reply = Reply.new
    end

    private
    def crate_params
        params.require(:crate).permit(:name,:description,:states_id, :all_tags,:price,:qualities_id,:locations_id,:category_id,:slug)
    end

    def correct_crate
        @crate = Crate.find(params[:id])
        redirect_to root_url if current_user.id != @crate.user.id
    end

    def check_user_status
        @user = friendly_find(params[:id]).user
        if @user.user_status_id > 1
            redirect_to root_url, notice: "The User of this crate has been inactivated"
        end
    end

    def friendly_find(id)
        Crate.friendly.find(id)
    end

end
