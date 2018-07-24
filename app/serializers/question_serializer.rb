class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :rating
  has_many :answers, if: :include_answers?
  has_many :comments, if: :include_comments?
  has_many :attachments, if: :include_attachments?

  def include_answers?
    instance_options[:show_answers]
  end

  def include_comments?
    instance_options[:show_comments]
  end

  def include_attachments?
    instance_options[:show_attachments]
  end
end
