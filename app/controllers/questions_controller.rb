class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :destroy, :update, :vote_up, :vote_down, :vote_delete]
  after_action :publish_question, only: [:create]

  def index
    @questions = Question.all
    @user_id = signed_in? ? current_user.id : 0
  end

  def show
    @answer = @question.answers.new
    @answer.attachments.build
    @vote = @question.vote_by_user(current_user)
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def create
    @question = Question.new(question_params)
    @question.author = current_user
    if @question.save
      flash[:notice] = 'The question was created successfully'
      redirect_to @question
    else
      render :new
    end
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
    end
    @questions = Question.all
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path
      flash[:notice] = 'Question was successfully deleted'
    else
      redirect_to @question
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        json: {
          question: @question,
          authors_template: ApplicationController.render(
            partial: 'questions/question',
            locals: { question: @question, user: @question.author }
            )
          }
      )
    )
  end

  def find_question
    @question = Question.find(params[:id])
  end
end
