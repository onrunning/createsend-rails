# frozen_string_literal: true
describe CreateSendRails::SailthruEmailFormatter do
  let(:message) { double(to: ['a@example.com', 'b@example.com'], 
												 cc: ['c@example.com', "c2@example.com"],
												bcc: ['d@example.com', "d2@example.com"]) }
  let(:parsed_body) {
    {
      "smart_email_id": "cbe13bc5-c090-4113-8de6-b8a2ef9edd6e",
      "sailthru_template_name": "automation-back-in-stock_FR",
      "delivery_system": "sailthru",
      "product": {
        "name": "Cloud",
        "color": "All Black",
        "link": "http://localhost:3000/fr-br/products/cloud/womens/all-black",
        "path": "/fr-br/products/cloud/womens/all-black",
        "size": "41",
        "price": "749.0",
        "currency": "BRL",
        "image_url": "https://images.ctfassets.net/od02wyo8cgm5/1GZSM9rakd46niymrR2Siz/cbe44c3412db37b1ebe4fc888c3b1d15/cloud_2-fw19-all_black-w-t.png"
      }
    }
  }
  let(:sailthru_formatter) { described_class.new(message, parsed_body) }

  describe 'constants' do
    it 'validates the constants values' do
      reserved_keys = %i[smart_email_id sailthru_template_name delivery_system]
      expect(CreateSendRails::SailthruEmailFormatter::RESERVED_KEYS).to eq(reserved_keys)
    end
  end

  describe 'request_body' do
		let(:parsed_response) { sailthru_formatter.send(:request_body) }

		it 'returns sailthru as delivery system' do
    	expect(parsed_response[:template]).to eq('automation-back-in-stock_FR')
		end

		it 'returns the list of emails that are in the "to" field' do
    	expect(parsed_response[:email]).to eq('a@example.com,b@example.com')
		end

		it 'returns the list of emails that are in under "cc" and "bcc" keys' do
    	expect(parsed_response[:options][:headers][:Cc]).to eq('c@example.com,c2@example.com')
			expect(parsed_response[:options][:headers][:Bcc]).to eq('d@example.com,d2@example.com')
		end

		it 'returns the product details that are under the "var" key' do
			expect(parsed_response[:vars][:product][:name]).to eq('Cloud')
			expect(parsed_response[:vars][:product][:currency]).to eq('BRL')
		end
  end
end
