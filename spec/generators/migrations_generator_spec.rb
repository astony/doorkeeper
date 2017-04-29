require 'spec_helper_integration'
require 'generators/doorkeeper/migrations_generator'

describe Doorkeeper::MigrationsGenerator do
  include GeneratorSpec::TestCase

  tests Doorkeeper::MigrationsGenerator
  destination ::File.expand_path('../tmp/dummy', __FILE__)

  describe 'after running the generator' do
    before :each do
      prepare_destination
      run_generator %w(--previous-refresh-token --application-owner)
    end

    it 'creates a migration' do
      assert_migration 'db/migrate/create_access_grants.rb'
      assert_migration 'db/migrate/create_access_tokens.rb'
      assert_migration 'db/migrate/add_previous_refresh_token_to_access_tokens.rb'
      assert_migration 'db/migrate/create_applications.rb'
      assert_migration 'db/migrate/add_owner_to_applications.rb'
      assert_migration 'db/migrate/create_users.rb'
    end
  end
end
