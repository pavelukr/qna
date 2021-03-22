class Question < ApplicationRecord
  validates :title, :body, presence: true
  has_many :answers
  has_many :attachments, as: :attachable
  has_many :votes, as: :votable
  belongs_to :user
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
end
