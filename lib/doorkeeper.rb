require 'doorkeeper/version'
require 'doorkeeper/engine'
require 'doorkeeper/config'
require 'doorkeeper/models'
require 'doorkeeper/migration'
require 'doorkeeper/orm'
require 'doorkeeper/errors'
require 'doorkeeper/server'
require 'doorkeeper/request'
require 'doorkeeper/validations'

require 'doorkeeper/oauth/authorization/code'
require 'doorkeeper/oauth/authorization/token'
require 'doorkeeper/oauth/authorization/uri_builder'
require 'doorkeeper/oauth/helpers/scope_checker'
require 'doorkeeper/oauth/helpers/uri_checker'
require 'doorkeeper/oauth/helpers/unique_token'

require 'doorkeeper/oauth/scopes'
require 'doorkeeper/oauth/error'
require 'doorkeeper/oauth/base_response'
require 'doorkeeper/oauth/code_response'
require 'doorkeeper/oauth/token_response'
require 'doorkeeper/oauth/error_response'
require 'doorkeeper/oauth/pre_authorization'
require 'doorkeeper/oauth/base_request'
require 'doorkeeper/oauth/authorization_code_request'
require 'doorkeeper/oauth/refresh_token_request'
require 'doorkeeper/oauth/password_access_token_request'
require 'doorkeeper/oauth/client_credentials_request'
require 'doorkeeper/oauth/code_request'
require 'doorkeeper/oauth/token_request'
require 'doorkeeper/oauth/client'
require 'doorkeeper/oauth/token'
require 'doorkeeper/oauth/invalid_token_response'
require 'doorkeeper/oauth/forbidden_token_response'

require 'doorkeeper/models/concerns'
require 'doorkeeper/models/mixins'

require 'doorkeeper/orm/base'
require 'doorkeeper/orm/active_record'

require 'doorkeeper/helpers/controller'

require 'doorkeeper/rails/routes'
require 'doorkeeper/rails/helpers'

require 'active_support/deprecation'

module Doorkeeper
  def self.authenticate(request, methods = Doorkeeper.configuration.access_token_methods)
    OAuth::Token.authenticate(request, *methods)
  end
end
