module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_user,  only: [:index, :update]
      before_action :authorize,          only: [:update]
      
      def index
        render json: {status: 200, msg: 'Logged-in'}
      end

      def create
        user = User.new(user_params)
        if user.save
          render json: {status: 200, user }
        end
      end

      def update
        user = User.find(params[:id])
        if user.update(user_params)
          render json: { status: 200, user }
        end
      end

      private
      def user_params
        params.require(:user).permit(:username, :email, :password, :password_confirmation)
      end
      
      def authorize
        return_unauthorized unless current_user && current_user.can_modify_user?(params[:id])
      end
    end
  end
end