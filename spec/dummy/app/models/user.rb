class User < ActiveRecord::Base
  self.table_name = 'oauth_users'
  include Doorkeeper::Models::Mixins::User
end
