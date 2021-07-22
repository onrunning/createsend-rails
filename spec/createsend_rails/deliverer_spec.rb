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
      let(:raw_source) { '{ "smart_email_id": "example-id-555", "delivery_system": "sailthru" }' }
      let(:message) { double(to: ['a@example.com', 'b@example.com'], 
                             cc: ['c@example.com', "c2@example.com"],
                             bcc: ['d@example.com', "d2@example.com"]) }
      let(:sailthru_mock_object) { double }

      it 'return successfully' do
        api_post_data = { email: message.to.join(','), options: { headers: { Cc: message.cc.join(','), Bcc: message.bcc.join(',') } } }

        message.stub_chain(:body, :raw_source).and_return(raw_source)
        expect_any_instance_of(described_class).to receive(:sailthru_client).and_return(sailthru_mock_object)
        expect(sailthru_mock_object).to receive(:api_post).with(:send, api_post_data).and_return(true)

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
