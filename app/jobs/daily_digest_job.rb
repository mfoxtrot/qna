class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    User.find_each { |user| DailyMailer.digest(user) }
  end
end
