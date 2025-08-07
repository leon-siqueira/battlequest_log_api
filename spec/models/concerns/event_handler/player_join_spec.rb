require 'rails_helper'

RSpec.describe EventHandler::PlayerJoin do
  let(:data) { { "id" => "p6", "name" => "Frank", "level" => 39 } }

  describe "#run" do
    it "creates a new player if not exists" do
      expect { described_class.call(data:) }.to change { Player.count }.by(1)
    end

    it "updates an existing player if already exists" do
      player = create(:player, logged_id: "p6", name: "", level: 1)
      described_class.call(data:)

      player = Player.find_by(logged_id: "p6")
      expect(player.name).to eq("Frank")
      expect(player.level).to eq(39)
    end
  end
end
