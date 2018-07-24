class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :question_params, only: [:create]

  authorize_resource

  def index
    @questions = Question.all
    respond_with @questions, include: [:answers]
  end

  def show
    @question = Question.find(params[:id])
    respond_with @question, include: [:comments, :attachments]
  end

  def create
    @question = Question.create(question_params)
    if @question.save
      respond_with @question, include: []
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body).merge!(author_id: current_resource_ownwer.id)
  end
end
