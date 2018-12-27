class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :question_params, only: [:create]

  authorize_resource

  def index
    @questions = Question.all.order(:id)
    respond_with @questions, include: [:answers]
  end

  def show
    @question = Question.find(params[:id])
    respond_with @question, include: [:comments, :attachments]
  end

  def create
    @question = Question.create(question_params)
    @question.author_id = current_resource_ownwer.id
    if @question.save
      respond_with @question, include: []
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
