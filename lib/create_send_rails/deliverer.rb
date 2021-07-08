module CreateSendRails
  class Deliverer
    attr_accessor :settings

    SAILTHRU = 'sailthru'.freeze
    CREATSEND = 'creatsend'.freeze

    def initialize(values)
      self.settings = {}.merge(values)
    end

    def deliver!(mail)
      @mail = mail

      delivery_system == SAILTHRU ? send_via_sailthru : send_via_createsend
    end

    private

    attr_reader :mail

    def sailthru_auth
      settings.dup
    end

    def send_via_createsend
      smart_email = ::CreateSend::Transactional::SmartEmail.new(auth, smart_email_id)
      smart_email.send(mail_data)
    end

    def send_via_sailthru
      sailthru_client.api_post(:send, sailthru_mail_data)
    end

    def sailthru_client
      Sailthru::Client.new
    end

    def delivery_system
      parsed_body[:delivery_system]
    end

    def smart_email_id
      parsed_body[:smart_email_id]
    end

    def sailthru_mail_data
      SailthruEmailFormatter.new(@mail, parsed_body).format
    end

    def mail_data
      SmartEmailFormatter.new(@mail, parsed_body).format
    end

    def parsed_body
      return {} unless @mail.try(:body).present?

      JSON.parse(@mail.try(:body).try(:raw_source)).symbolize_keys!
    end
  end
end
