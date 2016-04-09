class RepliesController < ApplicationController
    
    def create
        @q = Query.find(params[:reply][:query_id])
        @reply = @q.replies.build(reply_params)
        if @reply.save
            @reply.set_user!(current_user)
            @reply.create_activity :create, owner: current_user
            flash[:success] = 'Reply Posted'
            redirect_to @q.crate
        else
            flash[:error] =  @reply.errors.full_messages.join(", ")
            redirect_to @q.crate
        end
    end
    
    def reply_params
        params.require(:reply).permit(:query_id,:body)
    end
    
end
