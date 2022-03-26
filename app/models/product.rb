class Product < ApplicationRecord
    validates :name, presence: true
    validates :name, uniqueness: true
    belongs_to :category

    after_initialize :add_order

    private 
    def add_order
        self.order = self.id if self.order.nil?
    end 
end
