require 'rails_helper'

RSpec.describe AuthTokenValidator, type: :class do
  let(:params) { double('token') }

  describe '#valid_token?' do
    subject { described_class.new(params).valid_token? }

    context 'when the token is not present' do
      before do
        expect(params).to \
          receive(:[])
          .with(:token) { false }
      end

      it {
        expect { subject }.to \
          raise_error(
            AuthTokenValidator::RequiredParamsValidationError
          )
      }
    end

    context 'when the token is present' do
      let(:params) { double(:token, token: '5oqaIdbRVR4XlDb05tnrTg') }
      let(:decoded_token) { HashWithIndifferentAccess.new({ 'user_id': 1 }) }

      context 'and it has not expired' do
        it 'returns true' do
          expect(params).to \
            receive(:[])
              .with(:token) { params.token }
          expect(JsonWebToken).to \
            receive(:decode)
            .with(params.token) { decoded_token }

          expect(subject).to be_truthy
        end
      end

      context 'and it has expired' do
        it 'returns true' do
          expect(params).to \
            receive(:[])
            .with(:token) { params.token }
          expect(JsonWebToken).to \
            receive(:decode)
              .with(params.token)
              .and_raise(JsonWebToken::ExpiredSignature)
          expect(JsonWebToken).to \
            receive(:decode)
            .with(params.token, false ) { decoded_token }

          expect(subject).to be_truthy
        end
      end

      context 'and it cannot be decoded' do
        it 'raises an error' do
          expect(params).to \
            receive(:[])
            .with(:token) { params.token }
          expect(JsonWebToken).to \
            receive(:decode)
            .with(params.token)
            .and_raise(JsonWebToken::DecodeError)

          expect { subject }.to raise_error(JsonWebToken::DecodeError)
        end
      end
    end
  end

  describe 'refresh_token' do
    let(:params) { double(:token, token: '5oqaIdbRVR4XlDb05tnrTg') }
    let(:user) { double(:user, id: 1) }
    let(:auth_token_validator_instance) { described_class.new(params) }
    let(:decoded_token) { { 'exp' => 3.hours.ago.to_i } }

    subject { auth_token_validator_instance.refresh_token }

    context 'when the token is more than 2 hours old' do
      it 'raises an ExpiredToken error' do
        expect(params).to \
          receive(:[])
          .with(:token) { params.token }
        auth_token_validator_instance.instance_variable_set(
          :@user_id, user.id
        )
        auth_token_validator_instance.instance_variable_set(
          :@decoded_token, decoded_token
        )

        expect { subject }.to raise_error(AuthTokenValidator::ExpiredTokenError)
      end

    end

    context 'when the token is less that 2 hours old' do

      it 'is exchanged for a fresh user token' do
        expect(params).to \
          receive(:[])
          .with(:token) { params.token }
        auth_token_validator_instance.instance_variable_set(:@user_id, user.id)
        expect(User).to \
          receive(:find_by_id)
          .with(user.id) { user }

        expect(subject).to_not eq(params.token)
      end
    end

  end
end
