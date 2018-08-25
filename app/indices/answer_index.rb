ThinkingSphinx::Index.define :answer, with: :active_record do
  #fields
  indexes body
  indexes author.email, as: :author, sortable: true

  #attributes
  has author_id, type: :integer
  has created_at, type: :timestamp
  has updated_at, type: :timestamp
end