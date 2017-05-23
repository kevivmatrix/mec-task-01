class JobsController < ApplicationController

  def status
    respond_to do |format|
      # job_status = ActiveJobStatus.fetch(params[:job_id])
      # respose = {
      #   status: job_status.status,
      #   percent: job_status.percent
      # }
      # respose = {
      #   status: Sidekiq::Status::status(params[:job_id]),
      #   percent: Sidekiq::Status::at(params[:job_id])
      # }
      respose = {}
      format.json {
        render json: respose
      }
    end
  end

end
