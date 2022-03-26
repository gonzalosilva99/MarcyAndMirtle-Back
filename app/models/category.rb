class Category < ApplicationRecord
    validates :name, presence: true
    validates :name, uniqueness: true
    has_many :products
    
    after_initialize :add_order

    private 
    def add_order
        self.order = self.id if self.order.nil?
    end 
end
