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

            def products 
               @category = @categories.find(params[:id]) if params[:id]  
            end

            private 

            def category_params
                params.require(:category).permit(:name, 
                                        products: [:id, :name, :price, :description]
                                        )
            end

            def set_categories 
                @categories = Category.all
            end
        end
    end
end
