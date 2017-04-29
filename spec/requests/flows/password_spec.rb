require 'spec_helper_integration'

describe 'Resource Owner Password Credentials Flow not set up' do
  before do
    client_exists
    create_resource_owner
  end

  context 'with valid user credentials' do
    it 'doesn\'t issue new token' do
      expect do
        post password_token_endpoint_url(client: @client, resource_owner: @resource_owner)
      end.to_not change { Doorkeeper.configuration.access_token_model.constantize.count }
    end
  end
end

describe 'Resource Owner Password Credentials Flow' do
  before do
    config_is_set(:grant_flows, ["password"])
    config_is_set(:resource_owner_from_credentials) { Doorkeeper.configuration.user_model.constantize.authenticate! params[:username], params[:password] }
    client_exists
    create_resource_owner
  end

  context 'with valid user credentials' do
    it 'should issue new token with confidential client' do
      expect do
        post password_token_endpoint_url(client: @client, resource_owner: @resource_owner)
      end.to change { Doorkeeper.configuration.access_token_model.constantize.count }.by(1)

      token = Doorkeeper.configuration.access_token_model.constantize.first

      expect(token.application_id).to eq @client.id
      should_have_json 'access_token', token.token
    end

    it 'should issue new token with public client (only client_id present)' do
      expect do
        post password_token_endpoint_url(client_id: @client.uid, resource_owner: @resource_owner)
      end.to change { Doorkeeper.configuration.access_token_model.constantize.count }.by(1)

      token = Doorkeeper.configuration.access_token_model.constantize.first

      expect(token.application_id).to eq @client.id
      should_have_json 'access_token', token.token
    end

    it 'should issue new token without client credentials' do
      expect do
        post password_token_endpoint_url(resource_owner: @resource_owner)
      end.to change { Doorkeeper.configuration.access_token_model.constantize.count }.by(1)

      token = Doorkeeper.configuration.access_token_model.constantize.first

      expect(token.application_id).to be_nil
      should_have_json 'access_token', token.token
    end

    it 'should issue a refresh token if enabled' do
      config_is_set(:refresh_token_enabled, true)

      post password_token_endpoint_url(client: @client, resource_owner: @resource_owner)

      token = Doorkeeper.configuration.access_token_model.constantize.first

      should_have_json 'refresh_token', token.refresh_token
    end

    it 'should return the same token if it is still accessible' do
      allow(Doorkeeper.configuration).to receive(:reuse_access_token).and_return(true)

      client_is_authorized(@client, @resource_owner)

      post password_token_endpoint_url(client: @client, resource_owner: @resource_owner)

      expect(Doorkeeper.configuration.access_token_model.constantize.count).to be(1)
      should_have_json 'access_token', Doorkeeper.configuration.access_token_model.constantize.first.token
    end
  end

  context 'with invalid user credentials' do
    it 'should not issue new token with bad password' do
      expect do
        post password_token_endpoint_url(client: @client,
                                         resource_owner_username: @resource_owner.name,
                                         resource_owner_password: 'wrongpassword')
      end.to_not change { Doorkeeper.configuration.access_token_model.constantize.count }
    end

    it 'should not issue new token without credentials' do
      expect do
        post password_token_endpoint_url(client: @client)
      end.to_not change { Doorkeeper.configuration.access_token_model.constantize.count }
    end
  end

  context 'with invalid confidential client credentials' do
    it 'should not issue new token with bad client credentials' do
      expect do
        post password_token_endpoint_url(client_id: @client.uid,
                                         client_secret: 'bad_secret',
                                         resource_owner: @resource_owner)
      end.to_not change { Doorkeeper.configuration.access_token_model.constantize.count }
    end
  end

  context 'with invalid public client id' do
    it 'should not issue new token with bad client id' do
      expect do
        post password_token_endpoint_url(client_id: 'bad_id', resource_owner: @resource_owner)
      end.to_not change { Doorkeeper.configuration.access_token_model.constantize.count }
    end
  end
end
