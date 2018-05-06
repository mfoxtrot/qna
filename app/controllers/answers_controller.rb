class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:new, :create]
  before_action :find_answer, only: [:destroy, :update]

  def create
    @answer = @question.answers.create(answer_params)
    @answer.author = current_user
    if @answer.save
      flash[:notice] = 'New answer was added'
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Answer was successfully deleted'
    else
      flash[:error] = 'Cannot delete the answer'
    end
    @question = @answer.question
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
    end
    @question = @answer.question
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
