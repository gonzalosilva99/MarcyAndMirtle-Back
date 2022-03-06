class AddModifiedToShipments < ActiveRecord::Migration[7.0]
  def change
    add_column :shipments, :modified, :boolean
  end
end
