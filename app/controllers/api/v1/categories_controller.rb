module Api
    module V1
        class CategoriesController < ApplicationController
            before_action :authenticate_user!
            before_action :set_categories
            load_and_authorize_resource

            def index 
                render json: @categories.as_json
            end
             
            def show;
            end

            def create
                @category = Category.create(category_params)
                return render :show unless @category.invalid?
        
                render json: { errors: @category.errors.messages },
                       status: :unprocessable_entity
            end

            def update
                @category = Category.find params[:id]
                @category.update category_params
                return render :show unless @category.invalid?
        
                render json: { errors: @category.errors.messages },
                       status: :unprocessable_entity
            end

            def swap_categories_order
                if params[:category_id1]  && params[:category_id2]
                    category_1 = Category.find params[:category_id1]
                    category_2 = Category.find params[:category_id2]
                    orderaux = category_1.order
                    category_1.update(order: category_2.order)
                    category_2.update(order: orderaux)
                    return render json: { message: "Order changed succesfully " }, status: :ok 
                end
                render json: { errors: "There was an error with the products" },
                        status: :unprocessable_entity
            end

            def products 
               @category = @categories.find(params[:id]) if params[:id]  
            end

            private 

            def category_params
                params.require(:category).permit(:name,:category_id2, :category_id1,
                                        products: [:id, :name, :price, :description])
            end

            def set_categories 
                @categories = Category.all
            end
        end
    end
end
