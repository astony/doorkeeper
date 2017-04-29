require 'rails/generators/active_record'

# Work if Doorkeeper::Migration module is defined
#
class Doorkeeper::Migration::PreviousRefreshTokenGenerator < ::Rails::Generators::Base
  include Rails::Generators::Migration

  desc 'Provide support revoke refresh token on access token use.'

  source_root File.expand_path('../../templates/migrations', __FILE__)

  def previous_refresh_token
    migration_template(
      'add_previous_refresh_token_to_access_tokens.rb',
      'db/migrate/add_previous_refresh_token_to_access_tokens.rb'
    )
  end

  def self.next_migration_number(path)
    ActiveRecord::Generators::Base.next_migration_number(path)
  end

  private

  def no_previous_refresh_token_column?
    !ActiveRecord::Base.connection.column_exists?(
      :oauth_access_tokens,
      :previous_refresh_token
    )
  rescue ActiveRecord::StatementInvalid
    false
  end
end
