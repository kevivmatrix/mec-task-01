# ActiveJobStatus.store = ActiveSupport::Cache::MemoryStore.new
# ActiveJobStatus.store = ActiveSupport::Cache::RedisStore.new
ActiveJob::Status.store = :redis_store
