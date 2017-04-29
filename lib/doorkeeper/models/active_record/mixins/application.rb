module Doorkeeper
  module Models
    module Mixins
      module Application
        extend ActiveSupport::Concern

        include Doorkeeper::OAuth::Helpers
        include Doorkeeper::Models::Concerns::Scopes
        include ActiveModel::MassAssignmentSecurity if defined?(::ProtectedAttributes)

        included do
          has_many :access_grants, dependent: :delete_all, class_name: Doorkeeper.configuration.access_grant_model
          has_many :access_tokens, dependent: :delete_all, class_name: Doorkeeper.configuration.access_token_model

          has_many :authorized_tokens, -> { where(revoked_at: nil) }, class_name: Doorkeeper.configuration.access_token_model
          has_many :authorized_applications, through: :authorized_tokens, source: :application

          validates :name, :secret, :uid, presence: true
          validates :uid, uniqueness: true
          validates :redirect_uri, redirect_uri: true

          before_validation :generate_uid, :generate_secret, on: :create
        end

        class_methods do
          # Returns Applications associated with active (not revoked) Access Tokens
          # that are owned by the specific Resource Owner.
          #
          # @param resource_owner [ActiveRecord::Base]
          #   Resource Owner model instance
          #
          # @return [ActiveRecord::Relation]
          #   Applications authorized for the Resource Owner
          #
          def authorized_for(resource_owner)
            resource_access_tokens = Doorkeeper.configuration.access_token_model.constantize.active_for(resource_owner)
            where(id: resource_access_tokens.select(:application_id).distinct)
          end
          # Returns an instance of the Doorkeeper::Application with
          # specific UID and secret.
          #
          # @param uid [#to_s] UID (any object that responds to `#to_s`)
          # @param secret [#to_s] secret (any object that responds to `#to_s`)
          #
          # @return [Doorkeeper::Application, nil] Application instance or nil
          #   if there is no record with such credentials
          #
          def by_uid_and_secret(uid, secret)
            find_by(uid: uid.to_s, secret: secret.to_s)
          end

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

        def has_scopes?
          Doorkeeper.configuration.orm != :active_record ||
              Doorkeeper.configuration.application_model.constantize.column_names.include?("scopes")
        end

        def generate_uid
          if uid.blank?
            self.uid = UniqueToken.generate
          end
        end

        def generate_secret
          if secret.blank?
            self.secret = UniqueToken.generate
          end
        end
      end
    end
  end
end
