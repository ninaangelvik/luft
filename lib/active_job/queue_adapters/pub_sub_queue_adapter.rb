require "google/cloud"

module ActiveJob
  module QueueAdapters
    class PubSubQueueAdapter
      def self.pubsub
        pp "************"
        project_id = Rails.application.config.x.settings["project_id"]
        gcloud     = Google::Cloud.new project_id
        gcloud.pubsub
      end

      def self.enqueue job
        Rails.logger.info "[PubSubQueueAdapter] enqueue job #{job.inspect}"

        url  = job.arguments.first
        topic = pubsub.topic "ProcessInputQueue"

        topic.publish url
      end

      def self.run_worker!
        Rails.logger.info "Running worker to process input"
        
        topic        = pubsub.topic       "ProcessInputQueue"
        subscription = topic.subscription "InputSubscription"

        subscription.listen do |message|
          Rails.logger.info "Process input request (#{message.data})"

          url  = message.data
          data = StorageBucket.files.new key: url

          ProcessInputJob.perform_now data if data

          message.ack!
        end
      end
    end
  end
end