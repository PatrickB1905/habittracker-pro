class HabitSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :title, :description, :frequency, :public, :created_at, :updated_at
  set_type :habit
end
