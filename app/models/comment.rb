class Comment < ApplicationRecord
  validates :view, presence: true
  belongs_to :commentable, polymorphic: true, optional: true
end
