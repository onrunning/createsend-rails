module CreateSendRails
  class SailthruEmailFormatter
    RESERVED_KEYS = %i[smart_email_id sailthru_template_name delivery_system].freeze
    def initialize(message, parsed_body)
      @message = message
      @parsed_body = parsed_body
    end

    def format
      request_body.deep_reject! { |_k, v| v.blank? }
    end

    private

    attr_reader :message, :parsed_body

    def request_body
      {
        template: parsed_body[:sailthru_template_name],
        email:    message.to.join(','),
        vars:     parsed_body.except(*RESERVED_KEYS),
        **options
      }
    end

    def options
      return {} if cc.empty? && bcc.empty?

      {
        options: {
          headers: {
            **cc,
            **bcc
          }
        }
      }
    end

    def cc
      return {} unless message.cc

      { Cc: message.cc.join(',') }
    end

    def bcc
      return {} unless message.bcc

      { Bcc: message.bcc.join(',') }
    end
  end
end
