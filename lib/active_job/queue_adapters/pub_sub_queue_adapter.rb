require "google/cloud"
require "google/cloud/pubsub"

module ActiveJob
  module QueueAdapters
    class PubSubQueueAdapter
      def self.pubsub
        project_id = Rails.application.config.x.settings["project_id"]
        pubsub     = Google::Cloud::Pubsub.new project: project_id
        # pp pubsub.topics
        # pp "***************'"
        topic = pubsub.topic "ProcessInputQueue" 
        pubsub.create_topic "ProcessInputQueue" unless topic.exists?
        # pp "***********"
        # pp pubsub.topic("ProcessInputQueue")
        pubsub
      end

      def self.enqueue job
        Rails.logger.info "[PubSubQueueAdapter] enqueue job #{job.inspect}"
        pp "-------------------------"
        url  = job.arguments.first
        topic = pubsub.topic "ProcessInputQueue"
        pp topic
        topic.publish url
      end

      def self.run_worker!
        pp "Entering run_worker!"
        Rails.logger.info "Running worker to process input"

        topic        = pubsub.topic "ProcessInputQueue"
        
        subscription = topic.subscription "InputSubscription"
        topic.create_subscription "InputSubscription" unless subscription.exists? 

        # pp subscription
        subscription.pull.each do |message|
          Rails.logger.info "Process input request (#{message.data})"
          # pp message

          url  = message.data
          data = StorageBucket.files.first
          pp data.read
          ret = ProcessInputJob.perform_now data if data

          message.acknowledge! if ret == true
          unless ret == true
            pp ret
          end
        end
      end
    end
  end
end