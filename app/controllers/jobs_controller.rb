class JobsController < ApplicationController

  def status
    respond_to do |format|
      # job_status = ActiveJobStatus.fetch(params[:job_id])
      # response = {
      #   status: job_status.status,
      #   percent: job_status.percent
      # }
      # response = {
      #   status: Sidekiq::Status::status(params[:job_id]),
      #   percent: Sidekiq::Status::at(params[:job_id])
      # }
      job_status = ActiveJob::Status.get(params[:job_id])
      response = {
        status: job_status.status,
        percent: job_status.progress
      }
      format.json {
        render json: response
      }
    end
  end

end
