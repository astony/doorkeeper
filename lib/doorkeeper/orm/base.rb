module Doorkeeper
  module ORM
    class Base
      def self.initialize_models!
        raise Doorkeeper::Errors::NotImplemented
      end

      def self.initialize_application_owner!
        raise Doorkeeper::Errors::NotImplemented
      end
    end
  end
end
