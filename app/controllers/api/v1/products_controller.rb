module Api
    module V1
        class ProductsController < ApplicationController
            before_action :authenticate_user
            load_and_authorize_resource
            
            def index 
                @products = Product.where("name like ?", "%#{params[:search]}%") if params[:search]
            end
             
            def show;
            end

            def create
                @product = Product.create(product_params)
                return render :show unless @product.invalid?
        
                render json: { errors: @product.errors.messages },
                       status: :unprocessable_entity
            end

            def update
                @product = Product.find params[:id]
                @product.update product_params
                return render :show unless @product.invalid?
        
                render json: { errors: @product.errors.messages },
                       status: :unprocessable_entity
            end

            def search
                search = params[:search]
                @product = Product.where("name like ?", "#{search}%")
            end

            def swap_products_order
                if params[:product_id1]  && params[:product_id2]
                    product_1 = Product.find params[:product_id1]
                    product_2 = Product.find params[:product_id2]
                    orderaux = product_1.order
                    product_1.update(order: product_2.order)
                    product_2.update(order: orderaux)
                    return render json: { message: "Order changed succesfully " }, status: :ok 
                end 
                render json: { errors: "There was an error with the products" },
                           status: :unprocessable_entity
                
            end
            
            private 

            def product_params
                params.require(:product).permit(:name, :description, :price, :category_id, :search, :product_id2, :product_id1)
            end
        end
    end
end
