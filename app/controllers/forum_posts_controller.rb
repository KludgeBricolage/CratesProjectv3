class ForumPostsController < ApplicationController
    before_action :logged_in_user, only: [:create, :destroy, :edit, :new, :update]
    before_action :correct_f_user, only: [:destroy, :edit, :update]
    
    def correct_f_user
      @user = User.find(ForumPost.find(params[:id]).user_id)
      redirect_to(root_url) unless  current_user?(@user)
    end
    
    def new
        @forum_post = current_user.forum_posts.build
        @fcat = params[:forum_category_id]
    end
    
    def show
        @forum_post = ForumPost.find(params[:id])
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
    
    def edit
        @forum_post = ForumPost.find(params[:id])
    end
    
    def change_pin
        @forum_post = ForumPost.find(params[:id])
        @forum_post.toggle!(:is_pin)
        flash[:success] = 'Pin toggled'
        redirect_to @forum_post
    end
    
    def change_lock
        @forum_post = ForumPost.find(params[:id])
        @forum_post.toggle!(:is_lock)
        flash[:success] = 'Lock toggled'
        redirect_to @forum_post
    end
    
     def update
        @forum_post = ForumPost.find(params[:id])
        if  @forum_post.update_attributes(forum_post_params)
            flash[:success] = 'Post updated'
            redirect_to @forum_post
        else
            render 'edit'
        end
    end
    
    private
    def forum_post_params
        params.require(:forum_post).permit(:title,:description,:forum_category_id)
    end
    
end
