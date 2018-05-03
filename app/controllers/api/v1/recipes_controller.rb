module Api
  module V1
    class RecipesController < ApplicationController 

      before_action :authenticate_user

      def index
        recipes = Recipe.order('created_at DESC');
        recipes_representers = []
        recipes.each do |recipe|
          recipes_representers << RecipeRepresenter.new(recipe)
        end
        render json: recipes_representers.to_json, status: :ok
      end

      def show
        recipe = Recipe.find(params[:id])
        render json: RecipeRepresenter.new(recipe).to_json, status: :ok
      end

      def create
        recipe = Recipe.new(recipe_params.merge(user: current_user))
        if recipe.save
          render json: RecipeRepresenter.new(recipe), status: :ok
        else
          render json: recipe.erros, status: :unprocessable_entity
        end
      end

      def destroy
        recipe = Recipe.find(params[:id])
        recipe.destroy
        render json: RecipeRepresenter.new(recipe), status: :ok
      end

      def update
        recipe = Recipe.find(params[:id])
        if recipe.update(recipe_params)
          render json: RecipeRepresenter.new(recipe).to_json, status: :ok
        else
          render json: recipe.erros, status: :unprocessable_entity
        end
      end

      private
      def recipe_params
        params.permit(:name, :description, ingredients_attributes: [:id, :name, :measurement], 
          preparation_steps_attributes: [:id, :step, :description])
      end
    end
  end
end