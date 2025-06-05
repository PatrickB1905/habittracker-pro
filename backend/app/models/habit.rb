class Habit < ApplicationRecord
  belongs_to :user
  has_many :habit_entries, dependent: :destroy

  validates :title, presence: true
  validates :frequency, presence: true, inclusion: { in: %w[daily weekly monthly] }
end
