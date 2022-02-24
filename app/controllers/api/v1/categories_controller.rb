module Api
    module V1
        class CategoriesController < ApplicationController
            before_action :authenticate_user
            before_action :set_categories, only: %i[index show]

            def index 
                render json: @categories.as_json
            end
             
            def show
                authorize! :index, @categories
                return render json: @categories.find(params[:id]).as_json if params[:id]
            end

            def create
                @category = Category.create(category_params)
                return render :show unless @category.invalid?
        
                render json: { errors: @category.errors.messages },
                       status: :unprocessable_entity
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
