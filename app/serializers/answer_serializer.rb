class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :question_id, :created_at, :updated_at, :author_id, :best, :rating
  has_many :comments, if: :include_comments?
  has_many :attachments, if: :include_attachments?

  def include_comments?
    instance_options[:show_comments]
  end

  def include_attachments?
    instance_options[:show_attachments]
  end
end
