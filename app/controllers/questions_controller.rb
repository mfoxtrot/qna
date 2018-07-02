class QuestionsController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :destroy, :update, :vote_up, :vote_down, :vote_delete]
  before_action :build_nested_objects, only: [:show]
  after_action :publish_question, only: [:create]

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
          locals: { question: @question, user: @question.author }
          )
      }
    )
  end
end
