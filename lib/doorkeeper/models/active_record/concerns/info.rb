# frozen_string_literal: true
module Doorkeeper
  module Models
    module Concerns
      module Info
        extend ActiveSupport::Concern

        included do
          validates :name,
                    presence: true

          validates :email,
                    presence: true,
                    uniqueness: true,
                    format: /\A[\w+\-.]+@[a-z\-.]+\.[a-z]+\z/i
        end
      end
    end
  end
end
