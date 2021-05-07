class AddIndexes < ActiveRecord::Migration[6.1]
  def change
    add_index :comments, [:commentable_id, :commentable_type]
    add_index :comments, :view
    add_index :answers, :best
    add_index :answers, :body
    add_index :questions, :title
    add_index :votes, [:votable_id, :votable_type]
  end
end
