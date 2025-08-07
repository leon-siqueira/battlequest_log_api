require 'rails_helper'

RSpec.describe EventHandler::Score do
  let(:data) { { "player_id" => "p3", "score" => 681, "reason" => "defeated_monster" } }

  describe "#run" do
    it "creates a new player if not exists with the score earned" do
      expect { described_class.call(data:) }.to change { Player.count }.by(1)
      player = Player.find_by(logged_id: "p3")
      expect(player).not_to be_nil
      expect(player.score).to eq(681)
    end

    it "adds score to the player's current amount if player already exists" do
      player = create(:player, logged_id: "p3", score: 100)
      described_class.call(data:)

      player = Player.find_by(logged_id: "p3")
      expect(player.score).to eq(781)
    end

    it "keeps the score as it was if those data are not valid on to_i" do
      data["score"] = "invalid"
      described_class.call(data:)

      player = Player.find_by(logged_id: "p3")
      expect(player.score).to eq(0)
    end
  end
end
