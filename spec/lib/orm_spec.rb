require 'spec_helper_integration'

describe Doorkeeper::ORM do
  subject { Doorkeeper::ORM }

  context 'when have correct orm' do
    before do
      Doorkeeper.configure do
        orm 'active_record'
      end
    end

    describe 'initialize' do
      it 'configure orm successfully' do
        expect(subject.initialize!).to eq('Doorkeeper::ORM::ActiveRecord')
      end
    end
  end

  context 'when have incorrect orm' do
    before do
      Doorkeeper.configure do
        orm 'hibernate'
      end
    end

    describe 'initialize' do
      it 'adds specific error message to NameError exception' do
        expect { subject.initialize! }.to raise_error(NameError, /ORM adapter not found \(hibernate\)/)
      end
    end
  end
end
