ThinkingSphinx::Index.define :user, with: :active_record do
  #fields
  indexes email, as: :user, sortable: true

  #attributes
  has created_at, type: :timestamp
  has updated_at, type: :timestamp
end
