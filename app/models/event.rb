class Event < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_one_attached :image, dependent: :destroy
  belongs_to :user

  validates :title, length: { minimum: 5, maximum: 30 }
end
