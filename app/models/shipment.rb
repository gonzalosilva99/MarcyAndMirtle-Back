class Shipment < ApplicationRecord
    has_many :shipment_products
    has_many :products, through: :shipment_products
    accepts_nested_attributes_for :shipment_products, allow_destroy: true
end
