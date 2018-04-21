class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:new, :create]

  def create
    @answer = @question.answers.create(answer_params)
    @answer.author = current_user
    if @answer.save
      flash[:notice] = 'New answer was added'
    else
      render 'questions/show'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Answer was successfully deleted'
    else
      flash[:error] = 'Cannot delete the answer'
    end
    redirect_to question_path(@answer.question)
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
