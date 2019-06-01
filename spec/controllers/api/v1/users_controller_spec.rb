require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do

  describe "POST #register" do
    let(:params) { { username: 'john doe', email: 'john@example.com', password: 'password' } }

    subject { post :register , params: params }

    it "creates a new user" do
      expect { subject }.to change { User.count }.by(1)
    end

    context 'when a user with the same email ID already exists' do
      before { subject }

      it 'returns http bad request' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an error message in the response' do
        email_error = JSON.parse(response.body)['email']
        expect(email_error).to eq(["has already been taken"])
      end
    end

    context 'when the params are all blank' do
      let(:params) { { } }

      before { subject }

      it 'returns http bad request' do
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an error message in the response for all the fields' do
        errors = JSON.parse(response.body)
        expect(errors['email']).to eq(["can't be blank"])
        expect(errors['username']).to eq(["can't be blank"])
        expect(errors['password']).to eq(["can't be blank"])
      end
    end
  end

  describe 'POST #login' do

  end
end
