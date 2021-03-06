class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :question_id, :created_at, :updated_at, :author_id, :best, :rating
  has_many :comments
  has_many :attachments
end
