class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:new, :create]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.create(answer_params)
    @answer.author = current_user
    if @answer.save
      flash[:notice] = 'New answer was added'
      redirect_to question_path(@question)
    else
      render :new
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if @answer.author == current_user
      @answer.destroy
      flash[:notice] = 'Answer was successfully deleted'
      redirect_to question_path(@answer.question)
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :author)
  end
end
