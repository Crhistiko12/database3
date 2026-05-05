class Sale < ApplicationRecord
  belongs_to :product

  validates :buyer_name, presence: true
  validates :buyer_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
