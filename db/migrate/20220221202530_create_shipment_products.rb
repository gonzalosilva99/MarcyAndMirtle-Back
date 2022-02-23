class CreateShipmentProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :shipment_products do |t|
      t.integer :units
      t.belongs_to :product, null: false, foreign_key: true 
      t.belongs_to :shipment, null: false, foreign_key: true
      t.timestamps
    end
  end
end
