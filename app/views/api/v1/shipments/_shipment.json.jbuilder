json.id shipment.id
json.date shipment.created_at.strftime("%e/%m/%Y")
json.time shipment.created_at.strftime("%H:%M")
json.status shipment.status
json.modified shipment.modified
json.shipment_products shipment.shipment_products, partial: 'api/v1/shipment_products/shipment_product', as: :shipment_product
json.shipped_products shipment.shipped_products, partial: 'api/v1/shipped_products/shipped_product', as: :shipped_product if shipment.status != 'wasted'
