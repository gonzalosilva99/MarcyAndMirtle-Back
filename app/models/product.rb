class Product < ApplicationRecord
    validates :name, presence: true
    validates :name, uniqueness: true
    belongs_to :category
end
