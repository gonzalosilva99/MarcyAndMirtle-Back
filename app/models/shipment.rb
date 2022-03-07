class Shipment < ApplicationRecord
    enum status: [:requested, :accepted, :cancelled]
    has_many :shipment_products
    has_many :products, through: :shipment_products
    accepts_nested_attributes_for :shipment_products, allow_destroy: true
    after_initialize :init

    def init 
        status = :requested if status.nil?
        modified = false if modified.nil?
    end

    def duplicate
        c = Cart.new cart_id: cart.id, cart_user_id: cart_user.id
        # copy another attributes inside this method
        c
    end
end
