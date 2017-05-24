# ActiveJobStatus.store = ActiveSupport::Cache::MemoryStore.new
# ActiveJobStatus.store = ActiveSupport::Cache::RedisStore.new
# ActiveJob::Status.store = Rails.cache
ActiveJob::Status.store = ActiveSupport::Cache::RedisStore.new("#{ENV['REDISTOGO_URL'] || "redis://localhost:6379/"}0/cache")
# ActiveJob::Status.store = :redis_store
