require 'tempfile'

module Doorkeeper
  class InstallGenerator < ::Rails::Generators::Base

    desc 'Installs Doorkeeper.'

    source_root File.expand_path('../templates', __FILE__)

    def install
      template 'initializer.rb', 'config/initializers/doorkeeper.rb'
      template 'locales/en.yml.erb', 'config/locales/doorkeeper.en.yml'
      route 'use_doorkeeper'
      readme 'README'
    end
  end
end


