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
        basecamp = BasecampApi.new(config['domain'], config['user'], config['pass'], true)
        message = {:title => short_message,
          :body => full_message,
        :category_id => config['category_id']}
        basecamp.post_message(config['project_id'], message)
      end

    private

      def short_message
        "Build #{build.short_commit_identifier} of #{build.project.name} #{build.successful? ? "was successful" : "failed"}"
      end

      def full_message
        <<-EOM
Commit Message: #{build.commit_message}
Commit Date: #{build.commited_at}
Commit Author: #{build.commit_author}

#{stripped_build_output}
EOM
      end
      
    end
  end
end
