require "google/cloud"
require "google/cloud/pubsub"

module ActiveJob
  module QueueAdapters
    class PubSubQueueAdapter
      def self.pubsub
        project_id = Rails.application.config.x.settings["project_id"]
        pubsub     = Google::Cloud::Pubsub.new project: project_id
        
        topic = pubsub.topic "ProcessInputQueue" 
        pubsub.create_topic "ProcessInputQueue" unless topic.exists?
        
        pubsub
      end

      def self.enqueue job
        Rails.logger.info "[PubSubQueueAdapter] enqueue job #{job.inspect}"
        filename  = job.arguments.first
        topic = pubsub.topic "ProcessInputQueue"
        topic = pubsub.create_topic "ProcessInputQueue" unless topic.exists?
        topic.publish filename
      end

      def self.run_worker!
        pp "Entering run_worker!"
        Rails.logger.info "Running worker to process input"

        topic        = pubsub.topic "ProcessInputQueue"
        
        subscription = topic.subscription "InputSubscription"
        topic.create_subscription "InputSubscription" unless subscription.exists? 

        subscription.pull.each do |message|
          Rails.logger.info "Process input request (#{message.data})"
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