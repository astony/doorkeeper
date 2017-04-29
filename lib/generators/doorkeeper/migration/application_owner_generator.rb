require 'rails/generators/active_record'

# Work if Doorkeeper::Migration module is defined
#
class Doorkeeper::Migration::ApplicationOwnerGenerator < ::Rails::Generators::Base
  include Rails::Generators::Migration

  desc 'Provide support for client application ownership migration.'

  source_root File.expand_path('../../templates/migrations', __FILE__)

  def application_owner
    migration_template(
      'add_owner_to_applications.rb',
      'db/migrate/add_owner_to_applications.rb'
    )
  end

  def self.next_migration_number(dirname)
    ActiveRecord::Generators::Base.next_migration_number(dirname)
  end

  private

  def no_application_owner_column?
    no_owner_id_column = !ActiveRecord::Base.connection.column_exists?(
        :oauth_applications,
        :owner_id
    )
    no_owner_type_column = !ActiveRecord::Base.connection.column_exists?(
        :oauth_applications,
        :owner_type
    )
    no_owner_id_column && no_owner_type_column
  rescue ActiveRecord::StatementInvalid => e
    false
  end
end