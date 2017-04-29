module Doorkeeper
  module Models
    module Mixins
      module AccessGrant
        extend ActiveSupport::Concern

        include Doorkeeper::OAuth::Helpers
        include Doorkeeper::Models::Concerns::Expirable
        include Doorkeeper::Models::Concerns::Revocable
        include Doorkeeper::Models::Concerns::Accessible
        include Doorkeeper::Models::Concerns::Scopes
        include ActiveModel::MassAssignmentSecurity if defined?(::ProtectedAttributes)

        included do
          belongs_to_options = {
            class_name: Doorkeeper.configuration.application_model,
            inverse_of: :access_grants
          }
          if defined?(ActiveRecord::Base) && ActiveRecord::VERSION::MAJOR >= 5
            belongs_to_options[:optional] = true
          end

          belongs_to :application, belongs_to_options

          validates :resource_owner_id, :application_id, :token, :expires_in, :redirect_uri, presence: true
          validates :token, uniqueness: true

          before_validation :generate_token, on: :create
        end

        class_methods do
          # Searches for Doorkeeper::AccessGrant record with the
          # specific token value.
          #
          # @param token [#to_s] token value (any object that responds to `#to_s`)
          #
          # @return [Doorkeeper::AccessGrant, nil] AccessGrant object or nil
          #   if there is no record with such token
          #
          def by_token(token)
            find_by(token: token.to_s)
          end
        end

        private

        # Generates token value with UniqueToken class.
        #
        # @return [String] token value
        #
        def generate_token
          self.token = UniqueToken.generate
        end
      end
    end
  end
end
