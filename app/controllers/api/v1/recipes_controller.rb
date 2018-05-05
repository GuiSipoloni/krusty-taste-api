module Api
  module V1
    class RecipesController < ApplicationController 

      before_action :authenticate_user

      def index
        render json: RecipeManager.new.list_all(params).to_json, status: :ok
      end

      def show
        render json: RecipeManager.new.details(params).to_json, status: :ok
      rescue ActiveRecord::RecordNotFound => e
        render json: {message: "Recipe not found"}, status: :not_found
      end

      def create
        render json: RecipeManager.new(recipe_params).to_json, status: :ok
      rescue Exception => e
          render json: e.message, status: :bad_request
      end

      def destroy
        RecipeManager.new.delete(params)
        render json: {message: "delete success"}, status: :ok
      rescue Exception => e
        render json: e.message, status: :unauthorized
      end

      def update
          render json: RecipeManager.new.update(recipe_params).to_json, status: :ok
      rescue Exception => e 
          render json: e.message, status: :bad_request
      end

      private
      def recipe_params
        params.permit(:name, :description, ingredients_attributes: [:id, :name, :measurement], 
          preparation_steps_attributes: [:id, :step, :description])
      end
    end
  end
end