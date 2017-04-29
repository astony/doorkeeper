require 'spec_helper_integration'
require 'generators/doorkeeper/migration/previous_refresh_token_generator'

describe Doorkeeper::Migration::PreviousRefreshTokenGenerator do
  include GeneratorSpec::TestCase

  tests Doorkeeper::Migration::PreviousRefreshTokenGenerator
  destination ::File.expand_path('../tmp/dummy', __FILE__)

  describe 'after running the generator' do
    before :each do
      prepare_destination
      FileUtils.mkdir(::File.expand_path('config', Pathname(destination_root)))
      FileUtils.copy_file(::File.expand_path('../templates/routes.rb', __FILE__), ::File.expand_path('config/routes.rb', Pathname.new(destination_root)))
      run_generator
    end

    it 'creates a migration' do
      assert_migration 'db/migrate/add_previous_refresh_token_to_access_tokens.rb'
    end
  end
end
