class Answer < ApplicationRecord
  validates :body, presence: true
  belongs_to :question
  belongs_to :user
end
