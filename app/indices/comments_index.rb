ThinkingSphinx::Index.define :comment, with: :active_record do
  # fields
  indexes view, sortable: true

  # attributes
  has commentable_id, commentable_type, user_id, created_at, updated_at
end
