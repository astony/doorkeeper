module Doorkeeper
  module ORM
    class ActiveRecord < Base
      def self.initialize_models!
        Doorkeeper.configuration.models.each do |model|
          establish_connection(model) if establish_options
        end
      end

      def self.initialize_application_owner!
        Doorkeeper.configuration.application_model.constantize.send :include, Doorkeeper::Models::Concerns::Ownership
      end

      def self.establish_connection(model)
        model.constantize.send :establish_connection, establish_options
      end

      def self.establish_options
        Doorkeeper.configuration.orm_options[:establish_connection]
      end
    end
  end
end
