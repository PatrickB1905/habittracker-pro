require 'rails_helper'

RSpec.describe Habit, type: :model do
  let(:user) { FactoryBot.create(:user) }

  it 'is valid with a title, frequency, and user' do
    habit = FactoryBot.build(:habit, user: user)
    expect(habit).to be_valid
  end

  it 'is invalid without a title' do
    habit = FactoryBot.build(:habit, title: nil, user: user)
    expect(habit).not_to be_valid
  end

  it 'is invalid without a frequency' do
    habit = FactoryBot.build(:habit, frequency: nil, user: user)
    expect(habit).not_to be_valid
  end

  it 'rejects invalid frequency values' do
    habit = FactoryBot.build(:habit, frequency: 'yearly', user: user)
    expect(habit).not_to be_valid
  end

  it 'belongs to a user' do
    habit = FactoryBot.build(:habit, user: user)
    expect(habit.user).to eq(user)
  end
end
