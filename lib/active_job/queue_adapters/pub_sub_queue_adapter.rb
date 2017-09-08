require "google/cloud"

module ActiveJob
  module QueueAdapters
    class PubSubQueueAdapter

      def self.pubsub
        project_id = Rails.application.config.x.settings["project_id"]
        gcloud     = Google::Cloud.new project_id

        gcloud.pubsub
      end

      def self.enqueue job
        Rails.logger.info "[PubSubQueueAdapter] enqueue job #{job.inspect}"

        url  = job.arguments.first
        topic = pubsub.topic "process_input_queue"

        topic.publish url
      end

      def self.run_worker!
        Rails.logger.info "Running worker to process input"
        
        topic        = pubsub.topic       "process_input_queue"
        subscription = topic.subscription "process_input"

        topic.subscribe "process_input" unless subscription.exists?

        subscription.listen autoack: true do |message|
          Rails.logger.info "Process input request (#{message.data})"

          url  = message.data
          data = StorageBucket.files.new key: url

          LookupBookDetailsJob.perform_now data if data
        end
      end
    end
  end
end