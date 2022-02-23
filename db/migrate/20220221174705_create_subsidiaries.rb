class CreateSubsidiaries < ActiveRecord::Migration[7.0]
  def change
    create_table :subsidiaries do |t|

      t.timestamps
    end
  end
end
