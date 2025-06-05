require 'rails_helper'

RSpec.describe 'Habits API', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:token) { JsonWebToken.encode(user_id: user.id, email: user.email) }
  let(:headers) do
    {
      'Authorization' => "Bearer #{token}",
      'Content-Type'  => 'application/json'
    }
  end
  let(:invalid_headers) { { 'Authorization' => nil } }

  describe 'GET /api/v1/habits' do
    before do
      FactoryBot.create_list(:habit, 3, user: user)
    end

    it 'returns user habits' do
      get '/api/v1/habits', headers: headers, as: :json

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['data'].size).to eq(3)
    end

    it 'returns unauthorized if no token and no public param' do
      get '/api/v1/habits', headers: invalid_headers, as: :json
      expect(response).to have_http_status(401)
    end
  end

  describe 'POST /api/v1/habits' do
    let(:valid_params) do
      {
        habit: {
          title:       'Meditate',
          description: 'Daily meditation',
          frequency:   'daily',
          public:      false
        }
      }
    end

    it 'creates a new habit' do
      expect {
        post '/api/v1/habits',
             params:  valid_params,
             headers: headers,
             as:      :json
      }.to change(Habit, :count).by(1)

      expect(response).to have_http_status(201)
    end

    it 'returns error on invalid data' do
      bad_params = { habit: { title: '', frequency: 'yearly' } }
      post '/api/v1/habits',
           params:  bad_params,
           headers: headers,
           as:      :json

      expect(response).to have_http_status(422)
      json = JSON.parse(response.body)
      expect(json['errors']).to include("Title can't be blank")
    end
  end

  describe 'GET /api/v1/habits/:id' do
    let(:habit) { FactoryBot.create(:habit, user: user) }

    it 'returns the habit' do
      get "/api/v1/habits/#{habit.id}", headers: headers, as: :json
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['data']['attributes']['title']).to eq(habit.title)
    end

    it 'returns not_found for another user’s habit' do
      other_user  = FactoryBot.create(:user)
      other_habit = FactoryBot.create(:habit, user: other_user)
      get "/api/v1/habits/#{other_habit.id}", headers: headers, as: :json
      expect(response).to have_http_status(404)
    end
  end

  describe 'PUT /api/v1/habits/:id' do
    let(:habit)         { FactoryBot.create(:habit, user: user, title: 'OldTitle') }
    let(:valid_update)  { { habit: { title: 'NewTitle' } } }

    it 'updates the habit' do
      put "/api/v1/habits/#{habit.id}",
          params:  valid_update,
          headers: headers,
          as:      :json

      expect(response).to have_http_status(200)
      habit.reload
      expect(habit.title).to eq('NewTitle')
    end
  end

  describe 'DELETE /api/v1/habits/:id' do
    let!(:habit) { FactoryBot.create(:habit, user: user) }

    it 'deletes the habit' do
      expect {
        delete "/api/v1/habits/#{habit.id}", headers: headers, as: :json
      }.to change(Habit, :count).by(-1)

      expect(response).to have_http_status(204)
    end
  end

  describe 'GET /api/v1/habits?public=true' do
    let!(:public_habit)  { FactoryBot.create(:habit, public: true) }
    let!(:private_habit) { FactoryBot.create(:habit, public: false) }

    it 'returns only public habits without auth' do
      get '/api/v1/habits?public=true', as: :json
      expect(response).to have_http_status(200)

      json   = JSON.parse(response.body)
      titles = json['data'].map { |h| h['attributes']['title'] }

      expect(titles).to include(public_habit.title)
      expect(titles).not_to include(private_habit.title)
    end
  end
end
