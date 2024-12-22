class Comment < ApplicationRecord
  belongs_to :event
  belongs_to :user

  validates :author, presence: true
end
