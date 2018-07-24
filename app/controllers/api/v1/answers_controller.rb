class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: [:index]

  def index
    @answers = @question.answers
    respond_with @answers, show_answers: true
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end
end
