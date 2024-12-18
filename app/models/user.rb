class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :events, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :name, presence: true
  validates :last_name, presence: true
  validates :email_address, presence: true, uniqueness: true
  validates :password, presence: true, confirmation: true
end
