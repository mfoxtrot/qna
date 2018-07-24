class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: [:index, :create]
  before_action :find_answer, only: [:show]
  before_action :answer_params, only: [:create]

  authorize_resource

  def index
    @answers = @question.answers
    respond_with @answers, include: []
  end

  def show
    respond_with @answer, include: [:comments, :attachments]
  end

  def create
    @answer = @question.answers.create(answer_params)
    if @answer.save
      respond_with @answer, include: []
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body).merge!(author_id: current_resource_ownwer.id)
  end
end
