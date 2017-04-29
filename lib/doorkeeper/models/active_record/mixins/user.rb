module Doorkeeper
  module Models
    module Mixins
      module User
        extend ActiveSupport::Concern

        include Doorkeeper::Models::Concerns::Info
        include Doorkeeper::Models::Concerns::DatabaseAuthenticatable
        include Doorkeeper::OAuth::Helpers

        included do
          before_validation :generate_uid, on: :create
        end

        class_methods do
          # Returns an instance of the Doorkeeper::Application with specific UID.
          #
          # @param uid [#to_s] UID (any object that responds to `#to_s`)
          #
          # @return [Doorkeeper::Application, nil] Application instance or nil
          #   if there is no record with such UID
          #
          def by_uid(uid)
            find_by(uid: uid.to_s)
          end
        end

        private

        def generate_uid
          if uid.blank?
            self.uid = UniqueToken.generate
          end
        end
      end
    end
  end
end
