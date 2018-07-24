class Api::V1::QuestionsController < Api::V1::BaseController

  def index
    @questions = Question.all
    respond_with @questions, show_answers: true
  end

  def show
    @question = Question.find(params[:id])
    respond_with @question, show_comments: true, show_attachments: true
  end
end
