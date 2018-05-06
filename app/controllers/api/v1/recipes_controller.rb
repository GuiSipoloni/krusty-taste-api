module Api
  module V1
    class RecipesController < ApplicationController 

      before_action :authenticate_user, except: [:index, :show]

      def index
        render json: RecipeManager.new.list_all_publics(params).to_json, status: :ok
      end

      def private_list
        render json: RecipeManager.new.list_all_privates(params, current_user).to_json, status: :ok
      end

      def show
        render json: RecipeManager.new.details(params, current_user).to_json, status: :ok
      rescue ActiveRecord::RecordNotFound => e
        render json: {message: "Recipe not found"}, status: :not_found
      rescue Exception => e
        render json: {message: e}, status: :unauthorized
      end

      def create
        render json: RecipeManager.new.create(recipe_params, current_user).to_json, status: :ok
      rescue Exception => e
        render json: {message: e}, status: :bad_request
      end

      def destroy
        RecipeManager.new.delete(params, current_user)
        render json: {message: "delete success"}, status: :ok
      rescue ActiveRecord::RecordNotFound => e
        render json: {message: "Recipe not found"}, status: :not_found
      rescue Exception => e
        render json: {message: e}, status: :unauthorized
      end

      def update
          render json: RecipeManager.new.update(recipe_params, current_user).to_json, status: :ok
      rescue Exception => e 
          render json: {message: e}, status: :bad_request
      end

      private
      def recipe_params
        params.permit(:id, :name, :description, :public, ingredients_attributes: [:id, :name, :measurement], 
          preparation_steps_attributes: [:id, :step, :description])
      end
    end
  end
end