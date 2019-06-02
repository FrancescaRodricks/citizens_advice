require 'rails_helper'

RSpec.describe Api::V1::GroupsController, type: :controller do

  describe 'POST create' do
    let(:user) { create(:user, username: 'test user', email: 'test.user@example.com', password: 'test213') }
    let(:params) {{ name: 'group name' }}
    let(:headers) {{ 'HTTP_ACCEPT' => "application/json", 'token' => token } }

    subject do
      request.headers.merge! headers
      post :create, params: params
    end

    context 'when the token is valid' do
      let(:token) { JsonWebToken.encode(user_id: user.id) }

      context 'and the user is an admin' do
        before do
          user.admin = true
          user.save
        end
        it 'creates a new group' do
          expect { subject }.to change { Group.count }.by(1)
        end
      end
    end

    context 'when the token is not valid' do
      let(:token) { "FAKE TOKEN" }

      it 'raises an unauthorized error' do
        expect(subject).to have_http_status(:unauthorized)
      end
    end
  end

end