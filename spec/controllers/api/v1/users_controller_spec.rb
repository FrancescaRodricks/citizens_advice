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
    let(:user) { create(:user, username: 'test user', email: 'test.user@example.com', password: 'test213') }

    subject { post :login , params: params }

    before { subject }

    context 'when the user exists' do

      context 'and the params are valid' do
        let(:params) { { username: user.username, password: user.password } }

        it 'returns a token in the response' do
          expect(JSON.parse(response.body)["token"]).to_not be_empty
        end
      end

      context 'and the username is not present in the request params' do
        let(:params) { { password: 'test213'} }

        it 'returns an error message' do
          expect(JSON.parse(response.body)["message"]).to eq('Username cannot be blank')
        end
      end

      context 'and the password is not present in the request params' do
        let(:params) { { username: 'test user'} }

        it 'returns an error message' do
          expect(JSON.parse(response.body)["message"]).to eq('Password cannot be blank')
        end
      end

    end
    context 'when the user doesnt exist' do
      let(:params) { { username: 'test user', password: 'test password'} }

      it 'returns an error message' do
        expect(JSON.parse(response.body)["message"]).to eq('User not found for given username and password')
      end
    end
  end

  describe 'PUT #refresh_token' do


  end
end
