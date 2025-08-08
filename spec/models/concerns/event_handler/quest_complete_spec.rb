require 'rails_helper'

RSpec.describe EventHandler::QuestComplete do
  let(:data) { { "player_id" => "p1", "quest_id" => "q42", "xp" => 100, "gold" => 50 } }
  describe "#run" do
    it "completes a quest for the player and awards experience and gold" do
      player = create(:player, logged_id: "p1", xp: 100, gold: 50)
      quest = create(:quest, logged_id: "q42")
      player_quest = create(:player_quest, player:, quest:)

      expect { described_class.call(data:) }.to change { PlayerQuest.where(player:, quest:, status: "completed").count }.by(1)
      expect(player.reload.xp).to eq(200)
      expect(player.gold).to eq(100)
    end

    it "creates player and quest if they do not exist and marks quest as completed" do
      expect { described_class.call(data:) }.to change { Player.count }.by(1).and change { Quest.count }.by(1)
      player = Player.find_by(logged_id: "p1")
      quest = Quest.find_by(logged_id: "q42")
      expect(player).not_to be_nil
      expect(quest).not_to be_nil
      expect(PlayerQuest.where(player:, quest:, status: "completed").count).to eq(1)
    end

    it "raises an error if quest data is invalid" do
      data["quest_id"] = "invalid_format"
      expect { described_class.call(data:) }.to raise_error("Quest data not valid")
    end

    it "raises an error if player data is invalid" do
      data["player_id"] = "invalid_format"
      expect { described_class.call(data:) }.to raise_error("Player data not valid")
    end
  end
end
