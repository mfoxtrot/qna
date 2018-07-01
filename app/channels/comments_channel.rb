class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "comments-#{data['commentable']}-#{data['id']}"
  end
end
