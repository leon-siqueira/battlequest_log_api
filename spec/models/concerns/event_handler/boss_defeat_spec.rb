require 'rails_helper'

RSpec.describe EventHandler::BossDefeat do
  let(:data) { { "boss_name" => "GolemKing", "defeated_by" => "p6", "xp" => 100, "gold" => 50 } }

  describe "#run" do
    it "creates a new player if not exists with the amount of xp and gold earned" do
      expect { described_class.call(data:) }.to change { Player.count }.by(1)
      player = Player.find_by(logged_id: "p6")
      expect(player).not_to be_nil
      expect(player.xp).to eq(100)
      expect(player.gold).to eq(50)
    end

    it "adds xp and gold to the player's current amount if player already exists" do
      player = create(:player, logged_id: "p6", xp: 100, gold: 50)
      described_class.call(data:)

      player = Player.find_by(logged_id: "p6")
      expect(player.xp).to eq(200)
      expect(player.gold).to eq(100)
    end

    it "keeps the xp and gold as it was if those data are not valid on to_i" do
      data["xp"] = "invalid"
      data["gold"] = "invalid"
      described_class.call(data:)

      player = Player.find_by(logged_id: "p6")
      expect(player.xp).to eq(0)
      expect(player.gold).to eq(0)
    end
  end
end
