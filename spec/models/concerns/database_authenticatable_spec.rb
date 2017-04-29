require 'spec_helper_integration'

describe 'DatabaseAuthenticatable' do
  subject do
    Class.new do
      include Doorkeeper::Models::Concerns::DatabaseAuthenticatable
    end.new
  end

  it { should have_secure_password }
end
