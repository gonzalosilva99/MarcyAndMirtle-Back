class AddOrderToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :order, :integer
  end
end
