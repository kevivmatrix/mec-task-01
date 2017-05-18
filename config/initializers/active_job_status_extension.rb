module ActiveJobStatus
  class JobStatus

    attr_reader :status, :percent

    def initialize data
      @status = data[:status]
      @percent = data[:percent] || 0
    end

    def queued?
      status.to_sym == ENQUEUED
    end

    def working?
      status.to_sym == WORKING
    end

    def completed?
      status.to_sym == COMPLETED
    end

    def empty?
      status.nil?
    end
  
  end

  class JobTracker
    
    def enqueued
      store.write(
        job_id,
        { status: JobStatus::ENQUEUED.to_s, percent: 0 },
        expires_in: expiration || DEFAULT_EXPIRATION
      )
    end

    def performing percent=0
      store.write(
        job_id,
        { status: JobStatus::WORKING.to_s, percent: percent }
      )
    end

    def completed
      store.write(
        job_id,
        { status: JobStatus::COMPLETED.to_s, percent: 100 }
      )
    end

  end
end
