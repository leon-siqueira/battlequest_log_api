require 'rails_helper'

RSpec.describe Player, type: :model do
  fixtures :players

  describe 'validations' do
    context 'logged_id format' do
      it 'accepts valid format' do
        player = Player.new(logged_id: 'p123')
        expect(player).to be_valid
      end

      it 'rejects invalid format' do
        player = Player.new(logged_id: 'abc123')
        expect(player).not_to be_valid
        expect(player.errors[:logged_id]).to include('must be in the format "p<numeric_id>"')
      end
    end
  end

  describe 'defaults' do
    it 'sets numeric attributes to zero by default' do
      player = Player.create(logged_id: 'p999')
      expect(player).to be_persisted
      expect(player.id).to eq(999)
      expect(player.gold).to eq(0)
      expect(player.xp).to eq(0)
      expect(player.hp).to eq(0)
      expect(player.score).to eq(0)
      expect(player.level).to eq(1)
      expect(player.name).to eq('')
    end
  end
end
