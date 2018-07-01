module Commentable
  extend ActiveSupport::Concern
  include Rails.application.routes.url_helpers

  included do
    has_many :comments, as: :commentable, dependent: :destroy
  end
end
