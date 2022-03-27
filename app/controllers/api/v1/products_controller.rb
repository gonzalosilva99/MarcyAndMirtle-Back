module Api
    module V1
        class ProductsController < ApplicationController
            before_action :authenticate_user
            load_and_authorize_resource
            
            def index
                if params[:search]
                    @products = Product.where("name like ?", "%#{params[:search]}%")
                else 
                    @products = Product.all.order(:order)
                end
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
                #Precondition: This receive all the products and their order for an specific category
                #params[prodid] indicates the new order of prod with prodid
                # products_of_category = nil
                products_order = params["products"]
                if products_order
                    products_order.each do |prod|
                        product = Product.find(prod[0].to_i)
                        product.order = prod[1] 
                        product.save
                    end
                    return render json: { message: "Orders changed succesfully " }, status: :ok 
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
