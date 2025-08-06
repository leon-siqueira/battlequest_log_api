require 'rails_helper'

RSpec.describe Player, type: :model do
  let(:player) { build(:player, logged_id: 'p123') }

  describe 'validations' do
    context 'logged_id format' do
      it 'accepts valid format' do
        expect(player).to be_valid
      end

      it 'rejects invalid format' do
        player.logged_id = 'abc123'
        expect(player).not_to be_valid
        expect(player.errors[:logged_id]).to include('must be in the format "p<numeric_id>"')
      end
    end
  end

  describe 'defaults' do
    it 'sets numeric id to what comes after p on the logged_id before saving' do
      expect(player.id).to be_nil
      player.save
      expect(player).to be_persisted
      expect(player.id).to eq(123)
    end
  end
end
