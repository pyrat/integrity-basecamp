require 'rubygems'
require 'integrity'
require File.dirname(__FILE__) + '/basecamp-api.rb'

module Integrity
  class Notifier
    class Basecamp < Notifier::Base
      attr_reader :config

      def self.to_haml
        File.read File.dirname(__FILE__) / "config.haml"
      end
      

      def deliver!
        basecamp = BasecampApi.new(config['account'], config['user'], config['pass'], false)
        message = {:title => short_message,
          :body => full_message,
        :category_id => config['category_id']}
        basecamp.post_message(config['project_id'], message)
      end

    private

      def short_message
        "Build #{build.short_identifier} of #{build.project.name} (#{build.author.name}) #{build.successful? ? "was successful" : "failed"}"
      end

      def full_message
        <<-EOM
Commit Message: #{build.message}
Commit Date: #{build.committed_at}
Commit Author: #{build.author.name}

#{build.output}
EOM
      end
      
    end
  end
end
