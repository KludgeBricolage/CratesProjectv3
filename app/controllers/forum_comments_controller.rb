class ForumCommentsController < ApplicationController
    before_action :logged_in_user, only: [:create, :edit, :update]
    
    def create
        @forum_post = ForumPost.find(params[:forum_comment][:forum_post_id])
        @forum_comment = @forum_post.forum_comments.build(forum_comment_params)
        if @forum_comment.save
            @forum_post.subscriptions.create.set_user!(current_user) unless Subscription.where(user: current_user, forum_post: @forum_post).exists?        
            @forum_comment.create_activity :create, owner: current_user
            @forum_post.touch
            flash[:success] = 'Comment has been posted!'
            redirect_to @forum_post
        else
            render '/'
        end
    end
  
    def edit
        @forum_post = ForumPost.find(params[:forum_post_id])
        @forum_comment = ForumComment.find(params[:id])
    end
    
     def update
         @forum_post = ForumPost.find(params[:forum_post_id])
         @forum_comment = ForumComment.find(params[:id])
        if @forum_comment.update_attributes(forum_comment_params)
            flash[:success] = 'Comment Updated'
            redirect_to @forum_post
        else
            render 'edit'
        end
    end
    
    private
    def forum_comment_params
        params.require(:forum_comment).permit(:comment,:user_id)
    end
    
end
