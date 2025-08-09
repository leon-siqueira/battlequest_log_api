require 'rails_helper'

RSpec.describe EventHandler::ItemPickup do
  let(:data) { { "player_id" => "p1", "item" => "health_potion", "qty" => 2 } }
  describe "#run" do
    it "creates a player item record" do
      create(:player, logged_id: "p1")
      create(:item)
      expect { described_class.call(data:) }.to change { Player.find_by(logged_id: "p1").items.count }.by(1)
    end

    it "creates player and item if they do not exist" do
      expect { described_class.call(data:) }.to change { Player.count }.by(1).and change { Item.count }.by(1)
      player = Player.find_by(logged_id: "p1")
      item = Item.find_by(name: "health_potion")
      expect(player).not_to be_nil
      expect(item).not_to be_nil
      expect(player.items).to include(item)
    end

    it "raises an error if item data is invalid" do
      data["item"] = nil
      expect { described_class.call(data:) }.to raise_error("Item data not valid")
    end

    it "raises an error if player data is invalid" do
      data["player_id"] = "invalid_format"
      expect { described_class.call(data:) }.to raise_error("Player data not valid")
    end
  end
end
