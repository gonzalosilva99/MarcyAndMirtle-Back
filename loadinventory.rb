require 'csv'    

CSV.foreach('./Inventory.csv', headers: true) do |row|
    if row 
        category = Category.find_by_name(row.to_hash["category"])
        category = Category.create!(name: row.to_hash["category"]) unless category
        Product.create!(name: row.to_hash["﻿name"], price: row.to_hash["price"], category: category)
    end
end