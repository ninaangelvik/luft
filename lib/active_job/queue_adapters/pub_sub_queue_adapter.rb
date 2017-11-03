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

        subscription.listen max: 1 do |message|
          Rails.logger.error "Process input request (#{message.data})"
          filename  = message.data
          file = StorageBucket.files.get(filename)
          ret = ProcessInputJob.perform_now file.body
          message.acknowledge! if ret == true
          
          # if file.nil?
          #   pp "File not found"
          #   message.acknowledge!
          # else
          #   ret = ProcessInputJob.perform_now file.body
          #   message.acknowledge! if ret == true
          # end
        end
      end
    end
  end
end