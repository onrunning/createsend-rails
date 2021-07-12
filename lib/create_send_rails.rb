require 'action_mailer'
require 'create_send_rails/deliverer'
require 'create_send_rails/ext/action_mailer'
require 'create_send_rails/ext/hash'
require 'create_send_rails/sailthru_email_formatter'
require 'create_send_rails/smart_email_formatter'

module CreateSendRails
  extend self

  def install
    ActionMailer::Base.include(CreateSendRails::SmartEmailer)
    ActionMailer::Base.include(CreateSendRails::ViewDefaults)
    ActionMailer::Base.add_delivery_method :create_send, CreateSendRails::Deliverer
  end
end

if defined?(Rails)
  require 'create_send_rails/railtie'
else
  CreateSendRails.install
end
