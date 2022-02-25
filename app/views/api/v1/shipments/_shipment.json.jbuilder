json.id shipment.id
json.date shipment.created_at.strftime("%e/%m/%Y")
json.time shipment.created_at.strftime("%H:%M")
json.shipment_products shipment.shipment_products, partial: 'api/v1/shipment_products/shipment_product', as: :shipment_product
