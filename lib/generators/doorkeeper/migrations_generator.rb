require 'rails/generators/active_record'

class Doorkeeper::MigrationsGenerator < ::Rails::Generators::Base
  include Rails::Generators::Migration

  desc 'Installs Doorkeeper migration files.'

  source_root File.expand_path('../templates/migrations', __FILE__)

  class_option :application_owner, type: :boolean
  class_option :previous_refresh_token, type: :boolean

  def migrations
    migration_template 'create_applications.rb',
                       'db/migrate/create_applications.rb'
    migration_template 'create_access_grants.rb',
                       'db/migrate/create_access_grants.rb'
    migration_template 'create_access_tokens.rb',
                       'db/migrate/create_access_tokens.rb'
    if options.application_owner
      migration_template 'add_previous_refresh_token_to_access_tokens.rb',
                         'db/migrate/add_previous_refresh_token_to_access_tokens.rb'
    end
    if options.previous_refresh_token
      migration_template 'add_owner_to_applications.rb',
                         'db/migrate/add_owner_to_applications.rb'
    end
    migration_template 'create_users.rb',
                       'db/migrate/create_users.rb'
  end

  def self.next_migration_number(path)
    ActiveRecord::Generators::Base.next_migration_number(path)
  end
end
