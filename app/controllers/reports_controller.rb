class ReportsController < ApplicationController
    before_action :check_auth, only: [:show,:destroy,:index]
    
    def create
        @report = Report.new(report_params)
        if @report.save
            set_user(current_user)
            flash[:success] = 'Report has been submitted'
            redirect_to '/'
        else
            render 'new'
        end
    end    
    
    private
    def report_params
        params.require(:report).permit(:description,:reported_id,:reporter)
    end
    
end
