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

            def search
                search = params[:search]
                @product = Product.where("name like ?", "#{search}%")
            end

            private 

            def product_params
                params.require(:product).permit(:name, :description, :price, :category_id, :search)
            end
        end
    end
end
