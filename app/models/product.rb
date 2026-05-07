# app/models/product.rb
class Product < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  
  validates :name, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :stock, numericality: { greater_than_or_equal_to: 0 }
  
  # Validación de imagen
  validate :validate_image_type
  validate :validate_image_size

  private

  def validate_image_type
    return unless image.attached?
    
    allowed_types = ['image/png', 'image/jpg', 'image/jpeg', 'image/webp']
    unless allowed_types.include?(image.content_type)
      errors.add(:image, 'debe ser PNG, JPG, JPEG o WEBP')
    end
  end

  def validate_image_size
    return unless image.attached?
    
    if image.blob.byte_size > 5.megabytes
      errors.add(:image, 'no debe superar los 5MB')
    end
  end
end