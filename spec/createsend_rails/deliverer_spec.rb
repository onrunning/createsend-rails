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
      let(:request) { { api: 'abcdef', delivery_system: 'sailthru' } }
      let(:message) { double ( { body: { raw_source: { delivery_system: 'sailthru' } } } ) }

      it 'return successfully' do
        sailthru_mock_objct = double
        expect_any_instance_of(described_class).to receive(:sailthru_client).and_return(sailthru_mock_objct)
        expect(sailthru_mock_objct).to receive(:api_post).and_return(true)
        expect(message).to receive(:to).and_return(['example.email@example.com'])
        expect(message).to receive(:cc).at_least(:once).and_return(['example_cc_email@example.com'])
        expect(message).to receive(:bcc).at_least(:once).and_return(['example_bcc_email@example.com'])

        subject = described_class.new(request).deliver!(message)
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
