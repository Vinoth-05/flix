class User < ApplicationRecord
  has_secure_password
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, :username, :email, presence: true
  validates :email, uniqueness: {case_sensitive: false}
  validates :username, uniqueness: { case_sensitive: false }, format: { with:/\A[a-zA-Z0-9]*\z/ }
  validate :is_email_format_valid?
  has_many :reviews, dependent: :destroy
  has_many :movies, through: :reviews

  def is_email_format_valid?
    return false if email.blank?
    result = (email =~ VALID_EMAIL_REGEX)
    errors.add(:user, "Invalid email format.") if result != 0
  end
end
