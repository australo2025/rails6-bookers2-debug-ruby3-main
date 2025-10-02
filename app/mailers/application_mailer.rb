class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('SMTP_USERNAME', 'no-reply@example.com')
  layout 'mailer'
end