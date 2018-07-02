module Commented
  extend ActiveSupport::Concern

  included do
    before_action :set_commented, only: [:create_comment]
    after_action :publish_comment, only: [:create_comment]
  end

  def create_comment
    @comment = @commented.comments.new(body: comment_params[:comment_body])
    @comment.user = current_user
    @comment.save!
    respond_to do |format|
      format.json {
        render json: {comment: @comment, author: @comment.user}
      }
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_commented
    @commented = model_klass.find(params[:id])
  end

  def commentable
    params[:commentable]
  end

  def comment_params
    params.require(commentable.to_sym).permit(:comment_body)
  end

  def publish_comment
    return if @comment.errors.any?
    ActionCable.server.broadcast(
      "comments-#{commentable}-#{@comment.commentable.id}",
      {
        comment: @comment,
        author: @comment.user
      }
    )
  end
end
