class AddUserIdToAnswers < ActiveRecord::Migration[6.1]
  def change
    add_belongs_to :answers, :user
  end
end
