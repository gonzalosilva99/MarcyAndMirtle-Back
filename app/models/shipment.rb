class Shipment < ApplicationRecord
    enum status: [:requested, :accepted, :cancelled, :wasted]
    has_many :shipment_products
    has_many :shipped_products
    has_many :products, through: :shipment_products
    accepts_nested_attributes_for :shipment_products, allow_destroy: true
    accepts_nested_attributes_for :shipped_products, allow_destroy: true
    after_initialize :init

    def init 
        status = :requested if status.nil?
        modified = false if modified.nil?
    end

    scope :filter_by_status, -> (status) { where status: status }
    
    def duplicate
        c = Cart.new cart_id: cart.id, cart_user_id: cart_user.id
        # copy another attributes inside this method
        c
    end
end
