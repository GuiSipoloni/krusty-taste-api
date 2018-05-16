module Api
  module V1
    class RecipesController < ApplicationController 

      before_action :authenticate_user, except: [:index, :show]

      before_action :validate, only: :create

      rescue_from Exceptions::NotOwner, with: :render_not_owner_response
      rescue_from Exceptions::BadValues, with: :render_bad_values_response
      rescue_from ActiveRecord::RecordInvalid, with: :render_bad_values_response
      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

      def index
        params[:limit] ||= 10
        params[:offset] ||= 0
        render json: Recipe.new.all_publics(params), status: :ok
      end

      def private_list
        params[:limit] ||= 10
        params[:offset] ||= 0
        render json: Recipe.new.all_privates(params, current_user), status: :ok
      end

      def show
        render json: Recipe.new.details(params[:id], current_user), status: :ok
      end

      def create
        render json: Recipe.new.create(recipe_params, current_user), status: :created
      end

      def destroy
        Recipe.new.delete(params[:id], current_user)
        render json: {message: "delete success"}, status: :ok
      end

      def update
          render json: Recipe.new.update(recipe_params, current_user), status: :ok
      end

      private

        def validate
          if params[:ingredients_attributes].size < 2
            raise Exceptions::BadValues.new("Needs more than one ingredient")

          end
        end

        def render_not_owner_response(exception)
          render json: {message: exception.message}, status: :unauthorized
        end

        def render_bad_values_response(exception)
          render json: {message: exception.message}, status: :bad_request
        end

        def render_not_found_response
          render json: {message: "Recipe not found"}, status: :not_found
        end

        def recipe_params
          params.permit(:id, :name, :description, :public, :image,
            ingredients_attributes: [:id, :name, :measurement], 
            preparation_steps_attributes: [:id, :step, :description])
        end
    end
  end
end