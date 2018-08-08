class SubscriptionsController < ApplicationController

  before_action :authenticate_user!
  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    @subscription = Subscription.create(question: @question, user: current_user)
    respond_to do |format|
      format.json {
        render json: { message: "You have successfully subscribed to the question", subscription_exists: true, link: subscription_path(@subscription) }
      }
    end
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.delete
    respond_to do |format|
      format.json {
        render json: { message: "You have successfully unsubscribed from the question", subscription_exists: false, link: question_subscriptions_path(@subscription.question) }
      }
    end
  end

end
