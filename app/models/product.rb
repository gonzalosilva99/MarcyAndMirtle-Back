class Product < ApplicationRecord
    has_many :shipment_products
    has_many :shipment, through: :shipment_products
    belongs_to :category
end
