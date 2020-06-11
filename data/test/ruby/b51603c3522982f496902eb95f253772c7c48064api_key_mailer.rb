class ApiKeyMailer < ActionMailer::Base
  default from: 'admin@stayntouch.com'

  def api_key_registered(api_key)
    @api_key = api_key
    email_body = get_email_body(@api_key)
    mail(to: api_key.email, subject: 'API Key Registered', body: email_body)
  end

  private

  def get_email_body(api_key)
    host =  ApiKeyMailer.default_url_options[:host]
    email_template = EmailTemplate.find_by_title('API Key Text')
    email_body = email_template.body
    email_body = email_body.gsub('@snt_logo', "#{host}/assets/logo.png")
      .gsub('@api_key', api_key)
      .gsub('@api_key_expiry', api_key.expiry_date)
      .gsub('@from_address', 'admin@stayntouch.com')
    email_body = email_body
    email_body
  end
end
