class ApplicationJob < ActiveJob::Base
  include ActiveJob::Status
  # include ActiveJobStatus::Hooks

  # def start_tracking!
  #   ActiveJobStatus.store.write(
  #     self.job_id, 
  #     { status: "working", percent: 0 }
  #   )
  # end

  # def track percent
  #   ActiveJobStatus.store.write(
  #     self.job_id, 
  #     { status: "working", percent: percent }
  #   )
  # end

  # def end_tracking!
  #   ActiveJobStatus.store.write(
  #     self.job_id, 
  #     { status: "completed", percent: 100 }
  #   )
  # end

  # def status
  #   ActiveJobStatus.fetch(self.job_id).status
  # end

  # def percent
  #   ActiveJobStatus.fetch(self.job_id).percent
  # end

end
