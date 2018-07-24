class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: [:index]
  before_action :find_answer, only: [:show]

  def index
    @answers = @question.answers
    respond_with @answers
  end

  def show
    respond_with @answer, show_comments: true, show_attachments: true
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
