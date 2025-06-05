require 'rails_helper'

RSpec.describe 'HabitEntries API', type: :request do
  let(:user)    { FactoryBot.create(:user) }
  let(:token)   { JsonWebToken.encode(user_id: user.id, email: user.email) }
  let(:headers) do
    {
      'Authorization' => "Bearer #{token}",
      'Content-Type'  => 'application/json'
    }
  end
  let(:habit) { FactoryBot.create(:habit, user: user) }

  describe 'GET /api/v1/habits/:habit_id/habit_entries' do
    before do
      FactoryBot.create(:habit_entry, habit: habit, completed_on: Date.today)
      FactoryBot.create(:habit_entry, habit: habit, completed_on: Date.today - 1)
      FactoryBot.create(:habit_entry, habit: habit, completed_on: Date.today - 2)
    end

    it 'returns entries for the habit' do
      get "/api/v1/habits/#{habit.id}/habit_entries", headers: headers, as: :json

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['data'].length).to eq(3)
    end

    it 'returns not_found if habit does not belong to user' do
      other_user  = FactoryBot.create(:user)
      other_habit = FactoryBot.create(:habit, user: other_user)

      get "/api/v1/habits/#{other_habit.id}/habit_entries",
          headers: headers,
          as:      :json

      expect(response).to have_http_status(404)
    end
  end

  describe 'POST /api/v1/habits/:habit_id/habit_entries' do
    let(:valid_params) { { habit_entry: { completed_on: Date.today } } }

    it 'creates a new entry' do
      expect {
        post "/api/v1/habits/#{habit.id}/habit_entries",
             params:  valid_params,
             headers: headers,
             as:      :json
      }.to change(HabitEntry, :count).by(1)

      expect(response).to have_http_status(201)
    end

    it 'rejects duplicate date' do
      FactoryBot.create(:habit_entry, habit: habit, completed_on: Date.today)

      post "/api/v1/habits/#{habit.id}/habit_entries",
           params:  valid_params,
           headers: headers,
           as:      :json

      expect(response).to have_http_status(422)
    end
  end
end
