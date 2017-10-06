require "google/cloud"
require "google/cloud/pubsub"

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

        filename  = job.arguments.first
        topic = pubsub.topic "ProcessInputQueue"

        topic.publish filename
      end

      def self.run_worker!
        Rails.logger.info "Running worker to process input"

        topic        = pubsub.topic "ProcessInputQueue"
        
        subscription = pubsub.subscription "InputSubscription"
        subscription = topic.create_subscription "InputSubscription" unless subscription.exists? 

        subscription.listen do |message|
          Rails.logger.error "Process input request (#{message.data})"
          filename  = message.data
          file = StorageBucket.files.get(filename)
          ret = ProcessInputJob.perform_now file.body unless file.nil?

          message.acknowledge! if ret == true
          unless ret == true
            pp ret
          end
        end
      end
    end
  end
end