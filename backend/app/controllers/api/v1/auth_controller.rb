module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :authorize_request, only: %i[signup login]

      # POST /api/v1/auth/signup
      def signup
        user = User.new(signup_params)
        if user.save
            token = JsonWebToken.encode(user_id: user.id, email: user.email)
            serialized = UserSerializer.new(user).serializable_hash[:data][:attributes]
            serialized[:id] = user.id
            render json: { token: token, user: serialized }, status: :created
        else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
    end

      # POST /api/v1/auth/login
      def login
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
            token = JsonWebToken.encode(user_id: user.id, email: user.email)
            serialized = UserSerializer.new(user).serializable_hash[:data][:attributes]
            serialized[:id] = user.id
            render json: { token: token, user: serialized }, status: :ok
        else
            render json: { errors: ['Invalid email or password'] }, status: :unauthorized
        end
    end

      private

      def signup_params
        params.permit(:email, :password, :password_confirmation)
      end
    end
  end
end
