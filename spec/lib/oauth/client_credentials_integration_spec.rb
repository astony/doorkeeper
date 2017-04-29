require 'spec_helper_integration'

module Doorkeeper::OAuth
  describe ClientCredentialsRequest do
    let(:server) { Doorkeeper.configuration }

    context 'with a valid request' do
      let(:client) { FactoryGirl.create :application }

      it 'issues an access token' do
        request = ClientCredentialsRequest.new(server, client, {})
        expect do
          request.authorize
        end.to change { Doorkeeper.configuration.access_token_model.constantize.count }.by(1)
      end
    end

    describe 'with an invalid request' do
      it 'does not issue an access token' do
        request = ClientCredentialsRequest.new(server, nil, {})
        expect do
          request.authorize
        end.to_not change { Doorkeeper.configuration.access_token_model.constantize.count }
      end
    end
  end
end
