FactoryBot.define do
  factory :habit_entry do
    association :habit
    completed_on { Date.today - rand(0..7) }
  end
end
