class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: [:index, :create]
  before_action :find_answer, only: [:show]
  before_action :answer_params, only: [:create]

  def index
    @answers = @question.answers
    respond_with @answers
  end

  def show
    respond_with @answer, show_comments: true, show_attachments: true
  end

  def create
    @answer = @question.answers.create(answer_params)
    if @answer.save
      respond_with @answer
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
    params.require(:answer).permit(:body, :author_id)
  end
end
