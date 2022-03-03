class Product < ApplicationRecord
    validates :name, presence: true
    validates :name, uniqueness: true
    has_many :shipment_products
    has_many :shipment, through: :shipment_products
    belongs_to :category
end
