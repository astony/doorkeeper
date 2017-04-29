class AccessGrant < ActiveRecord::Base
  self.table_name = 'oauth_access_grants'
  include Doorkeeper::Models::Mixins::AccessGrant
end
