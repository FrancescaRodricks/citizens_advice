RSpec.describe Authentication, type: :class do
  let(:user_object) { { username: 'john.doe', password: 'john.doe123' } }
  let(:user) { double('user', id: 1) }
  let(:auth_instance) { described_class.new(user_object) }

  before do
    expect(User).to receive(:find_by_username).with(user_object[:username]) { user }
  end

  describe 'authenticate' do
    subject { auth_instance.authenticate }

    context 'when required params are present' do
      it 'returns a user' do
        expect(user).to receive(:authenticate).with(user_object[:password]) { true }

        expect(subject).to eq(user)
      end
    end

    context 'when username is not present' do
      let(:user_object) { { password: 'john.doe123' } }

      it 'raises RequiredParamsValidationError' do
        expect { subject }.to raise_error(Authentication::RequiredParamsValidationError)
      end
    end

    context 'when password is not present' do
      let(:user_object) { { username: 'john' } }

      it 'raises RequiredParamsValidationError' do
        expect { subject }.to raise_error(Authentication::RequiredParamsValidationError)
      end
    end
  end

  describe 'generate_token' do
    subject { auth_instance.generate_token }

    it 'returns a JWT token' do
      expect(subject).to_not be_nil
    end
  end
end