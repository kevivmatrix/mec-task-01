class JobTrackersController < ApplicationController
  before_action :set_job_tracker

  def show
    respond_to do |format|
      format.json {
        render json: @job_tracker
      }
    end
  end

  private
  
    def set_job_tracker
      @job_tracker = JobTracker.find(params[:id])
    end

end
