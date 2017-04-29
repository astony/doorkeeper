class Application < ActiveRecord::Base
  self.table_name = 'oauth_applications'
  include Doorkeeper::Models::Mixins::Application
end
