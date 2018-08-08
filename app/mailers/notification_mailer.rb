class NotificationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.new_answer.subject
  #
  def new_answer(answer, user)
    @greeting = "Hi"
    @user = user
    @answer = answer
    mail to: user.email
  end
end
