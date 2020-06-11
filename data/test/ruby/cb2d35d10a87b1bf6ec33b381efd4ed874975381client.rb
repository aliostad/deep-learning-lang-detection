require 'smtpcom_api/request'
require 'smtpcom_api/helpers'

module SmtpcomApi
  class Client
    include Request

    attr_reader :api_key, :host

    def initialize(api_key, api_host='http://api.smtp.com')
      @api_key  = api_key
      @api_host = api_host
    end

    def account
      SmtpcomApi::Account.new(@api_key, @api_host)
    end

    def sender(label)
      SmtpcomApi::Sender.new(label, @api_key, @api_host)
    end

    def add_sender(attributes)
      SmtpcomApi::Sender.new(attributes[:label], @api_key, @api_host, post(:senders, :sender => attributes)['sender'])
    end
    alias_method :create_sender, :add_sender

    def senders
      get(:senders)['senders'].map{|s| SmtpcomApi::Sender.new(s['label'], @api_key, @api_host, s) }
    end

  end
end