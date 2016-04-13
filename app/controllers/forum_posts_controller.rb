class ForumPostsController < ApplicationController
    before_action :logged_in_user, only: [:create, :destroy, :edit, :new, :update]
    before_action :correct_f_user, only: [:destroy, :edit, :update]
    
    def correct_f_user
      @user = User.find(friendly_find(params[:id]).user_id)
      redirect_to(root_url) unless  current_user?(@user)
    end
    
    def new
        @forum_post = current_user.forum_posts.build
        @fcat = params[:forum_category_id]
    end
    
    def show
        @forum_post = friendly_find(params[:id])
        @forum_comment =  @forum_post.forum_comments.build
        @forum_comments = @forum_post.forum_comments.all
    end
    
    def create
        @forum_post = current_user.forum_posts.build(forum_post_params)
        if @forum_post.save
            @forum_post.subscriptions.create.set_user!(current_user)
            flash[:success] = 'Post has been posted!'
            redirect_to @forum_post
        else
            render '/'
        end   
    end
    
    def change_subsc
        @forum_post = friendly_find(params[:id])
        @subscription = Subscription.where(user_id: current_user.id, forum_post_id: params[:id]).first
        if @subscription != nil
            @subscription.toggle!(:is_active)
            if @subscription.is_active?
                message = "Subscribed to Post"
            else
                message = "Unsubscribed to Post"
            end
            
            redirect_to @forum_post, notice: message
        else
            Subscription.create(forum_post: @forum_post, user: current_user)
            redirect_to @forum_post, notice: 'Toggled Subscription'
        end
    end
    
    def edit
        @forum_post = friendly_find(params[:id])
    end
    
    def change_pin
        @forum_post = friendly_find(params[:id])
        @forum_post.toggle!(:is_pin)
        flash[:success] = 'Pin toggled'
        redirect_to @forum_post
    end
    
    def change_lock
        @forum_post = friendly_find(params[:id])
        @forum_post.toggle!(:is_lock)
        flash[:success] = 'Lock toggled'
        redirect_to @forum_post
    end
    
     def update
        @forum_post = friendly_find(params[:id])
        if  @forum_post.update_attributes(forum_post_params)
            flash[:success] = 'Post updated'
            redirect_to @forum_post
        else
            render 'edit'
        end
    end
    
    private
    def forum_post_params
        params.require(:forum_post).permit(:title,:description,:forum_category_id, :slug)
    end
    
    def friendly_find(id)
       ForumPost.friendly.find(id)
    end
    
end
