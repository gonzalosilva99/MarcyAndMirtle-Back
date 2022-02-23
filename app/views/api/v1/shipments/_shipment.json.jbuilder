json.id shipment.id
json.date shipment.date
json.shipment_products shipment.shipment_products, partial: 'api/v1/shipment_products/shipment_product', as: :shipment_product
