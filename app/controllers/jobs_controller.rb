class JobsController < ApplicationController

  def status
    respond_to do |format|
      job_status = ActiveJobStatus.fetch(params[:job_id])
      respose = {
        status: job_status.status,
        percent: job_status.percent
      }
      format.json {
        render json: respose
      }
    end
  end

end
