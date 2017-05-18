# ActiveJobStatus.store = ActiveSupport::Cache::MemoryStore.new
ActiveJobStatus.store = ActiveSupport::Cache::RedisStore.new
