module Api
    module V1
        class ShipmentsController < ApplicationController
            before_action :set_shipments, only: %i[index show]
            before_action :authenticate_user
            load_and_authorize_resource

            def index;
                if params[:date]
                    date = Date.parse(params[:date])
                    @shipments = @shipments.where(:created_at => date.beginning_of_day .. date.end_of_day)
                end
                @shipments = @shipments.order(created_at: :desc)
            end

            def show;
            end

            def create
                if shipment_params[:status]
                    @shipment = Shipment.create(shipment_params.merge(modified: false))
                else 
                    @shipment = Shipment.create(shipment_params.merge(status: :requested, modified: false))
                end
            end
            
            def destroy
                @survey.destroy
            end

            def update
                @shipment = Shipment.find params[:id]
                old_ship_prod = map_old_ship_prod
                @shipment.update shipment_params
                if was_modified(old_ship_prod, @shipment.shipped_products)
                    @shipment.modified = true 
                    @shipment.save
                end 
                return render :show unless @shipment.invalid?
        
                render json: { errors: @shipment.errors.messages },
                       status: :unprocessable_entity
            end

            def stats_by_month
                if params[:year] and params[:month]
                    year = params[:year].to_i
                    month = params[:month].to_i
                    @amount_per_shipping = []
                    @amount_by_category = {}
                    @amount_by_product = {}
                    @wasted_by_product = {}
                    @total_wasted = 0
                    @shipments = Shipment.where("extract(month from created_at) = ? and extract(year from created_at) = ?", month, year)
                    wasted = @shipments.filter_by_status('wasted')
                    @shipments = @shipments.filter_by_status(['accepted'])

                    @shipments.each do |shipment|
                        shipment.shipped_products.each do |ship_prod|
                            category = ship_prod.product.category
                            price = ship_prod.units * ship_prod.product.price
                            add_to_shipment(shipment.id, shipment.created_at.strftime("%e/%m/%Y"), price)
                            add_to_category(category.name,price)
                            add_to_product(ship_prod.product.name, price)
                        end 
                    end
                    wasted.each do |shipment|
                        shipment.shipment_products.each do |ship_prod|
                            price = ship_prod.units * ship_prod.product.price
                            @total_wasted += price
                            wasted_by_product(ship_prod.product.name,price)
                        end
                    end
                end
            end

            private

            def map_old_ship_prod
                quantity = {}
                @shipment.shipment_products.each do |shp|
                    quantity[shp.product_id] = shp.units
                end
                quantity
            end
            
            def was_modified(old, new)
                new.each do |shp|
                    units = old[shp.product_id]
                    return true if shp.units != units
                end
                return true if(old.size != new.size)
                false
            end

            def add_to_shipment(shipment, date,price)
                if @amount_per_shipping.find {|i| i[:id] == shipment} 
                    @amount_per_shipping.find {|i| i[:id] == shipment} [:amount] += price
                else
                    @amount_per_shipping.append({
                        id: shipment,
                        amount: price,
                        date: date
                    })
                end
            end

            def add_to_category(name,price)
                if @amount_by_category[name]
                    @amount_by_category[name] += price
                else
                    @amount_by_category[name] = price
                end
            end

            def add_to_product(name,price)
                if @amount_by_product[name]
                    @amount_by_product[name] += price
                else
                    @amount_by_product[name] = price
                end
            end

            def wasted_by_product(name,price)
                if @wasted_by_product[name]
                    @wasted_by_product[name] += price
                else
                    @wasted_by_product[name] = price
                end
            end

            def shipment_params
                params.require(:shipment)
                      .permit(:id, :date, :created_at, :status, :modified,
                              shipment_products_attributes: [:product_id, :units ],
                              shipped_products_attributes: [:product_id, :units ]
                    )
            end
            
            def set_shipments
                @shipments = Shipment.all
            end
        end
    end
end