class QuestionsController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[show destroy update vote_up vote_down vote_delete subscribe unsubscribe]
  before_action :build_nested_objects, only: :show
  after_action :publish_question, only: :create

  authorize_resource

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def create
    respond_with(@question = Question.create(question_params.merge!(author: current_user)))
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
    end
    respond_with(@questions = Question.all)
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
    end
    respond_with @question
  end

  def subscribe
    current_user.subscriptions << @question unless current_user.subscriptions.exists?(@question.id)
    respond_to do |format|
      format.json {
        render json: { message: "You have successfully subscribed to the question", subscription_exists: true, link: unsubscribe_question_path(@question) }
      }
    end
  end

  def unsubscribe
    current_user.subscriptions.delete(@question) if current_user.subscriptions.exists?(@question.id)
    respond_to do |format|
      format.json {
        render json: {message: "You have successfully unsubscribed from the question", subscription_exists: false, link: subscribe_question_path(@question) }
      }
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end

  def find_question
    @question = Question.find(params[:id])
  end

  def build_nested_objects
    @answer = @question.answers.new
    @comment = @question.comments.new
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      {
        question: @question,
        authors_template: ApplicationController.render(
          partial: 'questions/question',
          locals: { question: @question, user_can_edit_question: true }
          )
      }
    )
  end
end
