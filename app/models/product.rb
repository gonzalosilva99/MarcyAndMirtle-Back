class Product < ApplicationRecord
    validates :name, presence: true
    validates :name, uniqueness: true
    belongs_to :category

    after_create :add_order
    default_scope { order(order: :asc) }
    private 
    def add_order
        self.order = self.id if self.order.nil?
        self.save
    end 
end
