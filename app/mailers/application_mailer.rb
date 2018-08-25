class ApplicationMailer < ActionMailer::Base
  default from: "notification@#{ENV['HOST_NAME']}"
  layout 'mailer'
end
