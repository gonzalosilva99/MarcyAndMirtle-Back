class AddStatusToShipments < ActiveRecord::Migration[7.0]
  def change
    add_column :shipments, :status, :integer
  end
end
