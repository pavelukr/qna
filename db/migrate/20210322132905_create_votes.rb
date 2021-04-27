class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.integer :opinion
      t.integer :votable_id
      t.string :votable_type
      t.belongs_to :user
      t.timestamps
    end
  end
end
