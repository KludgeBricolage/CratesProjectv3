class ReportsController < ApplicationController
    before_action :check_auth, only: [:show,:destroy,:index]
    before_action :logged_in_user, only: [:create]
    def create
        @user = User.find_by(id: params[:report][:reported_id])
        @report = Report.new(report_params)
        if @report.save!
            @report.set_user!(current_user)
            redirect_to @user, notice: 'Report Submitted'
        else
            redirect_to @user, notice: 'Report Failed'
        end
    end    
    
    private
    def report_params
        params.require(:report).permit(:description,:reported_id)
    end
    
end
