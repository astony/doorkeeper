# frozen_string_literal: true
module Doorkeeper
  module Models
    module Concerns
      module DatabaseAuthenticatable
        extend ActiveSupport::Concern

        included do
          has_secure_password
        end

        class_methods do
          def authenticate!(name, password)
            find_by(name: name).try(:authenticate, password)
          end
        end
      end
    end
  end
end
