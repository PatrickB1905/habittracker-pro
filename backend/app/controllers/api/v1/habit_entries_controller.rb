module Api
  module V1
    class HabitEntriesController < ApplicationController
      before_action :authorize_request
      before_action :set_habit

      # GET /api/v1/habits/:habit_id/habit_entries
      def index
        @entries = @habit.habit_entries.order(completed_on: :desc)
        render json: HabitEntrySerializer.new(@entries).serializable_hash
      end

      # POST /api/v1/habits/:habit_id/habit_entries
      def create
        @entry = @habit.habit_entries.build(entry_params)
        if @entry.save
          render json: HabitEntrySerializer.new(@entry).serializable_hash, status: :created
        else
          render json: { errors: @entry.errors.full_messages }, status: 422
        end
      end

      private

      def set_habit
        @habit = @current_user.habits.find(params[:habit_id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: ['Habit not found'] }, status: 404
      end

      def entry_params
        params.require(:habit_entry).permit(:completed_on)
      end
    end
  end
end
