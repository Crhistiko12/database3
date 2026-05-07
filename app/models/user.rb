require "bcrypt"

class User < ApplicationRecord
  has_secure_password

  has_many :products, dependent: :destroy

  validates :email_address, presence: true, uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { password.present? }

  def generate_password_reset_token!
    update!(
      password_reset_token: SecureRandom.urlsafe_base64,
      password_reset_sent_at: Time.current
    )
  end

  def password_reset_token_valid?
    password_reset_sent_at.present? && password_reset_sent_at >= 2.hours.ago
  end

  def clear_password_reset_token!
    update!(password_reset_token: nil, password_reset_sent_at: nil)
  end
end
