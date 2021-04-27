class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.string :view
      t.integer :commentable_id
      t.string :commentable_type
      t.belongs_to :user
      t.timestamps
    end
  end
end
