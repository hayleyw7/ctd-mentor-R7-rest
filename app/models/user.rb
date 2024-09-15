class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true, uniqueness: true, format: { with: Devise.email_regexp }
  validates :password, presence: true, length: { in: Devise.password_length }
end
