class AnswersController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!
  before_action :find_question, only: [:new, :create]
  before_action :find_answer, only: [:destroy, :update, :set_as_the_best]
  after_action :publish_answer, only: :create

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

  def set_as_the_best
    @question = @answer.question
    if current_user.author_of?(@question)
      @question.set_the_best_answer(@answer)
    end
    @question.reload
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast(
      "answers-#{@answer.question.id}",
      ApplicationController.render( json: { answer: @answer } )
    )
  end
end
