module Api
    module V1
        class CategoriesController < ApplicationController
            before_action :authenticate_user!
            before_action :set_categories
            load_and_authorize_resource

            def index 
                @categories = Category.order(:order)
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
                if params["categories"]
                    params["categories"].each do |cat|
                        category = Category.find(cat[0].to_i)
                        category.order = cat[1]
                        category.save
                    end
                    return render json: { message: "Orders changed succesfully " }, status: :ok 
                end
                render json: { errors: "There was an error with the categories" },
                        status: :unprocessable_entity
            end

            def products 
               @category = @categories.find(params[:id]) if params[:id]
               @category.products = @category.products.sort_by{|e| e[:order]}
            end

            private 

            def get_old_category_order
                categories = []
                Category.all.order(:order).each do |cat|
                    categories[cat.id] = cat.order
                end
                categories
            end

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
