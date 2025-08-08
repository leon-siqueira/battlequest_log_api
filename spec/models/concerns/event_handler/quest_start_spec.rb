require 'rails_helper'

RSpec.describe EventHandler::QuestStart do
  let(:data) { { "player_id" => "p1", "quest_id" => "q42" } }
  describe "#run" do
    it "starts a quest for the player" do
      create(:player, logged_id: "p1")
      create(:quest, logged_id: "q42")
      expect { described_class.call(data:) }.to change { Player.find_by(logged_id: "p1").quests.count }.by(1)
    end

    it "creates player and quest if they do not exist" do
      expect { described_class.call(data:) }.to change { Player.count }.by(1).and change { Quest.count }.by(1)
      player = Player.find_by(logged_id: "p1")
      quest = Quest.find_by(logged_id: "q42")
      expect(player).not_to be_nil
      expect(quest).not_to be_nil
      expect(player.quests).to include(quest)
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
