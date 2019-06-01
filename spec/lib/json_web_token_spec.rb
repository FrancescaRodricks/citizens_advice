require 'rails_helper'

RSpec.describe JsonWebToken, type: :class do
  describe '.encode' do
    subject { described_class.encode({ user_id: 1}) }

    it 'returns a token of length 105 characters' do
      expect(subject.length).to eq(105)
    end
  end

  describe '.decode' do
    let(:token) { described_class.encode({ user_id: 1}) }

    subject { described_class.decode(token) }

    it 'decodes the token and returns the correct user id' do
      expect(subject['user_id']).to eq(1)
    end
  end

  # TODO write specs for other JWT errors raised
end
