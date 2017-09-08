desc "Run task queue worker"
task run_worker: :environment do
  ActiveJob::QueueAdapters::PubSubQueueAdapter.run_worker!
end