class PagesController < ApplicationController
    before_action :is_logged_in, only: [:home,:crate_manager]
    
    def home
        @active_crates = search_byst(current_user.id, 1)
        @inactive_crates = search_byst(current_user.id, 2)
        @fin_crates = search_byst(current_user.id, 3)
        
        @r_noti = PublicActivity::Activity.where( trackable: get_replies).order("created_at desc")
        @q_noti = PublicActivity::Activity.where( trackable: get_c_queries).order("created_at desc")
        @f_noti = PublicActivity::Activity.where( trackable: get_f_queries).order("created_at desc")
        
        #get notifications of your forum posts
    end     
    
    def crate_manager
        @active_crates = search_byst(current_user.id, 1)
        @inactive_crates = search_byst(current_user.id, 2)
        @fin_crates = search_byst(current_user.id, 3)    
    end
    
    def change_status
        Crate.find(params[:crate_id]).update_attributes(active_status_id: params[:active_id])
        redirect_to crate_manager_path
    end
    
    def community
        @users = User.all
        @groups = Group.all
        @forum_cat = ForumCategory.all
    end
    
    def home_guest
        
    end
    
    private
    def search_byst(us_id,st_id)
        Crate.where(["user_id = ? and active_status_id = ?", us_id , st_id])
    end
    
    def is_logged_in
        render :home_guest unless logged_in?
    end
    
    def get_c_queries
        c = Query.where(crate: current_user.crates)
    end
    
    #get replies from queries you replied
    def get_replies
        a = Reply.where(query_id: current_user.replies.map {|c| c.query_id }.uniq).where.not(user: current_user)
        b = Reply.where(query: current_user.queries).where.not(user: current_user)
        return a.concat(b)
    end
    
    def get_f_queries
        a = ForumComment.where(forum_post_id: current_user.forum_comments.map {|c| c.forum_post_id }.uniq).where.not(user: current_user)
        b = ForumComment.where(forum_post: current_user.forum_posts).where.not(user: current_user)
        return a.concat(b)
    end
    
    
end
