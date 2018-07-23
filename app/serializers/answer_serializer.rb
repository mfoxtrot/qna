class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :best, :rating, :created_at, :updated_at
end
