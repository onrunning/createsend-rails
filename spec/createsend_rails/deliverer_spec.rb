describe CreateSendRails::Deliverer do
  before(:all) do
    ActionMailer::Base.create_send_settings = { api_key: 'ABCDEFG' }
  end

  describe 'constants' do
    it 'validate the constants values' do
      expect(CreateSendRails::Deliverer::SAILTHRU).to eq('sailthru')
      expect(CreateSendRails::Deliverer::CREATSEND).to eq('creatsend')
    end
  end

  describe 'action_mailer' do
    it 'allows configuration settings' do
      expect(ActionMailer::Base.create_send_settings[:api_key]).to eq('ABCDEFG')
    end
  end

  describe 'delivery' do
    context 'valid delivery attributes' do
      subject { described_class.new(request).deliver!(message) }
      let(:request) { double(api: 'abcdef') }
      let(:message) { double }

      xit 'sends a request to the create_send API' do
        expect(subject).to eq(eukdlx)
      end

      xit 'return successfully' do
         expect(subject).to eq(true)
      end
    end


    context 'sailthru delivery' do
      subject { described_class.new(request).deliver!(message) }
      let(:request) { { api: 'abcdef', delivery_system: 'sailthru' } }
      let(:message) { double }

      it 'return successfully' do
         expect(subject).to eq(true)
      end
    end

    context 'missing API credentials' do
      subject { described_class.new(request).deliver!(message) }
      let(:request) { double }
      let(:message) { double }
    end

    context 'missing API credentials' do
      subject { described_class.new(request).deliver!(message) }
      let(:request) { double }
      let(:message) { double }
    end
  end
end
