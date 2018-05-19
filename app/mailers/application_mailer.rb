class ApplicationMailer < ActionMailer::Base
  default from: (ENV['DEFAULT_FROM_EMAIL'] or raise "Please set the DEFAULT_FROM_EMAIL var")
  layout 'mailer'
end
