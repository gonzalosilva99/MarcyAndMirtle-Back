# json.shipments @shipments, partial: 'shipment', as: :shipment
json.amount_by_shipping @amount_per_shipping
json.amount_by_category @amount_by_category
json.amount_by_product @amount_by_product
json.wasted_by_product @wasted_by_product
json.total_wasted @total_wasted.round(2)