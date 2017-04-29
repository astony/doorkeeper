module ModelHelper
  def client_exists(client_attributes = {})
    @client = FactoryGirl.create(:application, client_attributes)
  end

  def create_resource_owner(options = {})
    @resource_owner = FactoryGirl.create(:user, options)
  end

  def authorization_code_exists(options = {})
    @authorization = FactoryGirl.create(:access_grant, options)
  end

  def access_grant_should_exist_for(client, resource_owner)
    grant = Doorkeeper.configuration.access_grant_model.constantize.first

    expect(grant.application).to have_attributes(id: client.id).
      and(be_instance_of(Doorkeeper.configuration.application_model.constantize))

    expect(grant.resource_owner_id).to eq(resource_owner.id)
  end

  def access_token_should_exist_for(client, resource_owner)
    token = Doorkeeper.configuration.access_token_model.constantize.first

    expect(token.application).to have_attributes(id: client.id).
      and(be_instance_of(Doorkeeper.configuration.application_model.constantize))

    expect(token.resource_owner_id).to eq(resource_owner.id)
  end

  def access_grant_should_not_exist
    expect(Doorkeeper.configuration.access_grant_model.constantize.all).to be_empty
  end

  def access_token_should_not_exist
    expect(Doorkeeper.configuration.access_token_model.constantize.all).to be_empty
  end

  def access_grant_should_have_scopes(*args)
    grant = Doorkeeper.configuration.access_grant_model.constantize.first
    expect(grant.scopes).to eq(Doorkeeper::OAuth::Scopes.from_array(args))
  end

  def access_token_should_have_scopes(*args)
    grant = Doorkeeper.configuration.access_token_model.constantize.last
    expect(grant.scopes).to eq(Doorkeeper::OAuth::Scopes.from_array(args))
  end

  def uniqueness_error
    case DOORKEEPER_ORM
    when :active_record
      ActiveRecord::RecordNotUnique
    when :sequel
      error_classes = [Sequel::UniqueConstraintViolation, Sequel::ValidationFailed]
      proc { |error| expect(error.class).to be_in(error_classes) }
    when :mongo_mapper
      MongoMapper::DocumentNotValid
    when /mongoid/
      Mongoid::Errors::Validations
    else
      raise "'#{DOORKEEPER_ORM}' ORM is not supported!"
    end
  end
end

RSpec.configuration.send :include, ModelHelper
