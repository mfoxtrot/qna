class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :question_params, only: [:create]

  def index
    @questions = Question.all
    respond_with @questions, show_answers: true
  end

  def show
    @question = Question.find(params[:id])
    respond_with @question, show_comments: true, show_attachments: true
  end

  def create
    @question = Question.create(question_params)
    if @question.save
      respond_with @question
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, :author_id)
  end
end
