class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.string :view
      t.integer :votable_id
      t.string :votable_type
      t.belongs_to :user
      t.timestamps
    end
  end
end
