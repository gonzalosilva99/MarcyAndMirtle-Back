module Api
    module V1
        class ShipmentsController < ApplicationController
            before_action :set_shipments, only: %i[index show]
            before_action :authenticate_user

            def index;
            end

            def show 
                render json: @shipments.find(params[:id]).as_json
            end

            def create
                @shipment = Shipment.create(shipment_params)  
            end
            
            private 

            def shipment_params
                params.require(:shipment)
                      .permit(:id, :date, 
                              shipment_products_attributes: [:product_id, :units ]
                    )
            end
            
            def set_shipments
                @shipments = Shipment.all
            end
        end
    end
end