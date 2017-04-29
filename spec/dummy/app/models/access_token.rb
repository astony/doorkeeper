class AccessToken < ActiveRecord::Base
  self.table_name = 'oauth_access_tokens'
  include Doorkeeper::Models::Mixins::AccessToken
end
