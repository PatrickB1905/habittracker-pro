class HabitEntry < ApplicationRecord
  belongs_to :habit

  validates :completed_on, presence: true,
                           uniqueness: { scope: :habit_id }
  validate  :completed_on_cannot_be_in_future

  def completed_on_cannot_be_in_future
    if completed_on.present? && completed_on > Date.today
      errors.add(:completed_on, "can't be in the future")
    end
  end
end
