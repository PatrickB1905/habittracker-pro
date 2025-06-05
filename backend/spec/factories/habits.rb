FactoryBot.define do
  factory :habit do
    title { Faker::Lorem.unique.sentence(word_count: 2) }
    description { Faker::Lorem.sentence }
    frequency { %w[daily weekly monthly].sample }
    public { false }
    association :user
  end
end
