class HabitEntrySerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :completed_on
  belongs_to :habit
end
