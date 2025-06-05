require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  let(:user)    { FactoryBot.create(:user) }
  let(:headers) { { 'Content-Type' => 'application/json' } }

  describe 'POST /api/v1/auth/signup' do
    let(:valid_params) do
      {
        email:                 'newuser@example.com',
        password:              'Password123!',
        password_confirmation: 'Password123!'
      }
    end

    it 'creates a new user and returns token' do
      post '/api/v1/auth/signup',
           params:  valid_params,
           headers: headers,
           as:      :json

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['token']).to be_present
      expect(json['user']['email']).to eq('newuser@example.com')
    end

    it 'returns errors when email is taken' do
      FactoryBot.create(:user, email: 'dup@example.com')

      dup_params = {
        email:                 'dup@example.com',
        password:              'Password123!',
        password_confirmation: 'Password123!'
      }

      post '/api/v1/auth/signup',
           params:  dup_params,
           headers: headers,
           as:      :json

      expect(response).to have_http_status(422)

      json = JSON.parse(response.body)
      expect(json['errors']).to include('Email has already been taken')
    end
  end

  describe 'POST /api/v1/auth/login' do
    let(:login_params) { { email: user.email, password: 'Password123!' } }

    it 'logs in existing user and returns token' do
      post '/api/v1/auth/login',
           params:  login_params,
           headers: headers,
           as:      :json

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['token']).to be_present
    end

    it 'returns unauthorized with wrong password' do
      bad_params = { email: user.email, password: 'WrongPass' }

      post '/api/v1/auth/login',
           params:  bad_params,
           headers: headers,
           as:      :json

      expect(response).to have_http_status(:unauthorized)
      json = JSON.parse(response.body)
      expect(json['errors']).to include('Invalid email or password')
    end
  end
end
