require 'rails_helper'

RSpec.describe User, type: :model do
  let(:password) { "password" }
  let(:email) { 'john.doe@example.com' }

  subject { described_class.new }

  it 'is valid with valid attributes' do
    subject.username = 'John Doe'
    subject.email = email
    subject.password = password

    expect(subject).to be_valid
  end

  it 'is not valid without an email' do
    subject.username = 'John Doe'
    subject.password = password

    expect(subject).to_not be_valid
  end

  context 'when validating for unique email' do
    context 'when no user exists with the same email' do
      it 'is valid' do
        subject.username = 'John Doe'
        subject.email = email
        subject.password = password

        expect(subject).to be_valid
      end
    end

    context 'when a user exists with the same email' do
      let!(:user) { create(:user) }

      it 'is not valid' do
        subject.username = 'John Doe'
        subject.email = user.email
        subject.password = password

        expect(subject.invalid?).to be_truthy
      end
    end
  end
end
