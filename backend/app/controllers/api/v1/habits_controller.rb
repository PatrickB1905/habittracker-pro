module Api
  module V1
    class HabitsController < ApplicationController
      before_action :authorize_request, except: %i[index]
      before_action :set_habit, only: %i[show update destroy]

      # GET /api/v1/habits
      def index
        if params[:public] == 'true'
          @habits = Habit.where(public: true).order(created_at: :desc)
          return render json: HabitSerializer.new(@habits).serializable_hash
        end

        header  = request.headers['Authorization']
        token   = header.split(' ').last if header
        decoded = JsonWebToken.decode(token)
        @current_user = User.find_by(id: decoded[:user_id]) if decoded

        unless @current_user
          return render json: { errors: ['Invalid or missing token'] }, status: 401
        end

        @habits = @current_user.habits.order(created_at: :desc)
        render json: HabitSerializer.new(@habits).serializable_hash
      end

      # POST /api/v1/habits
      def create
        @habit = @current_user.habits.build(habit_params)
        if @habit.save
          render json: HabitSerializer.new(@habit).serializable_hash, status: :created
        else
          render json: { errors: @habit.errors.full_messages }, status: 422
        end
      end

      # GET /api/v1/habits/:id
      def show
        render json: HabitSerializer.new(@habit).serializable_hash
      end

      # PUT /api/v1/habits/:id
      def update
        if @habit.update(habit_params)
          render json: HabitSerializer.new(@habit).serializable_hash
        else
          render json: { errors: @habit.errors.full_messages }, status: 422
        end
      end

      # DELETE /api/v1/habits/:id
      def destroy
        @habit.destroy
        head :no_content
      end

      private

      def set_habit
        @habit = @current_user.habits.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: ['Habit not found'] }, status: 404
      end

      def habit_params
        params.require(:habit).permit(:title, :description, :frequency, :public)
      end
    end
  end
end
