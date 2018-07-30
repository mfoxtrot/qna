shared_examples_for 'API Commentable' do
  context 'comments' do
    let!(:comment) { create_comment }
    let!(:commentable) { comment.commentable }
    before {get "/api/v1/#{resources_name(commentable)}/#{commentable.id}", params: {format: :json, access_token: access_token.token}}

    it 'has a list of comments' do
      expect(response.body).to have_json_size(commentable.comments.count).at_path("#{resource_name(commentable)}/comments")
    end

    %w(id body user_id created_at updated_at).each do |attr|
      it "comment object has #{attr}" do
        expect(response.body).to be_json_eql(comment.send(attr).to_json).at_path("#{resource_name(commentable)}/comments/0/#{attr}")
      end
    end
  end

  def resource_name(obj)
    obj.class.name.underscore
  end

  def resources_name(obj)
    obj.class.name.underscore.pluralize
  end
end
