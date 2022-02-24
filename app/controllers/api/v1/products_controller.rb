module Api
    module V1
        class ProductsController < ApplicationController
            before_action :set_products, only: %i[index show]
            before_action :authenticate_user
            
            def index 
                if params[:search]
                    render json: @product = Product.where("name like ?", "%#{params[:search]}%")
                else
                    render json: @products.as_json
                end 
            end
             
            def show
                render json: @products.find(params[:id]).as_json
            end

            def create
                @product = Product.create(product_params)
                return render :show unless @product.invalid?
        
                render json: { errors: @product.errors.messages },
                       status: :unprocessable_entity
            end

            def search
                search = params[:search]
                @product = Product.where("name like ?", "#{search}%")
            end

            private 

            def product_params
                params.require(:product).permit(:name, :description, :price, :category_id, :search)
            end

            def set_products
                @products = Product.all
            end
        end
    end
end
