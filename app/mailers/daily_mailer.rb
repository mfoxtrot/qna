class DailyMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_mailer.digest.subject
  #
  def digest(user)
    @greeting = "Hi"
    date = Date.yesterday
    @questions = Question.where(created_at: date.midnight..date.end_of_day).includes(:author)

    mail to: user.email
  end
end
