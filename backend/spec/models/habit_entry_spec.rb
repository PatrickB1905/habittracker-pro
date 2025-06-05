require 'rails_helper'

RSpec.describe HabitEntry, type: :model do
  let(:habit) { FactoryBot.create(:habit) }

  it 'is valid with a habit and completed_on date' do
    entry = FactoryBot.build(:habit_entry, habit: habit)
    expect(entry).to be_valid
  end

  it 'is invalid without a completed_on date' do
    entry = FactoryBot.build(:habit_entry, completed_on: nil, habit: habit)
    expect(entry).not_to be_valid
  end

  it 'is invalid if completed_on is in the future' do
    entry = FactoryBot.build(:habit_entry, completed_on: Date.today + 1, habit: habit)
    expect(entry).not_to be_valid
  end

  it 'enforces uniqueness per day' do
    FactoryBot.create(:habit_entry, habit: habit, completed_on: Date.today)
    duplicate = FactoryBot.build(:habit_entry, habit: habit, completed_on: Date.today)
    expect(duplicate).not_to be_valid
  end
end
