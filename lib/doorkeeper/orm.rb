module Doorkeeper
  module ORM
    def self.initialize!
      setup_orm_adapter
      require_orm_models
      setup_orm_models
      setup_orm_application_owner if Doorkeeper.configuration.enable_application_owner?

      Doorkeeper.configuration.instance_variable_get('@orm_adapter')
    end

    def self.setup_orm_adapter
      Doorkeeper.configuration.instance_variable_set('@orm_adapter', "Doorkeeper::ORM::#{Doorkeeper.configuration.orm.to_s.classify}".constantize.to_s)
    rescue NameError => e
      fail e, "ORM adapter not found (#{Doorkeeper.configuration.orm})", <<-ERROR_MSG.squish
[doorkeeper] ORM adapter not found (#{Doorkeeper.configuration.orm}), or there was an error
trying to load it.

You probably need to add the related gem for this adapter to work with
doorkeeper.
      ERROR_MSG
    end

    def self.require_orm_models
      Doorkeeper.configuration.concerns.each do |concern|
        require "doorkeeper/models/#{Doorkeeper.configuration.orm.to_s}/concerns/#{concern}"
      end

      Doorkeeper.configuration.mixins.each do |mixin|
        require "doorkeeper/models/#{Doorkeeper.configuration.orm.to_s}/mixins/#{mixin}"
      end
    end

    def self.setup_orm_models
      Doorkeeper.configuration.instance_variable_get('@orm_adapter').constantize.initialize_models!
    end

    def self.setup_orm_application_owner
      Doorkeeper.configuration.instance_variable_get('@orm_adapter').constantize.initialize_application_owner!
    end
  end
end
