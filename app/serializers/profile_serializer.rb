class ProfileSerializer < ActiveModel::Serializer
  attributes :id, :email, :created_at, :updated_at, :admin
end
