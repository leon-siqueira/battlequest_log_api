require 'rails_helper'

RSpec.describe EventHandler::Death do
  let(:data) { { "victim_id" => "p3", "killer_id" => "p1", "method" => "sword" } }

  describe "#run" do
    it "creates a new player if not exists with kills / deaths " do
      expect { described_class.call(data:) }.to change { Player.count }.by(2)
      victim = Player.find_by(logged_id: "p3")
      expect(victim).not_to be_nil
      expect(victim.kills).to eq(0)
      expect(victim.deaths).to eq(1)
      expect(victim.hp).to eq(0)
      killer = Player.find_by(logged_id: "p1")
      expect(killer).not_to be_nil
      expect(killer.kills).to eq(1)
      expect(killer.deaths).to eq(0)
    end

    it "adds to the killer's kills" do
      killer = create(:player, logged_id: "p1", kills: 0)
      described_class.call(data:)

      killer = Player.find_by(logged_id: "p1")
      expect(killer.kills).to eq(1)
    end

    it "adds to the victim's deaths and sets hp to 0" do
      victim = create(:player, logged_id: "p3", deaths: 0, hp: 50)
      described_class.call(data:)

      victim = Player.find_by(logged_id: "p3")
      expect(victim.deaths).to eq(1)
      expect(victim.hp).to eq(0)
    end

    it "raises an error if killer data is invalid" do
      data["killer_id"] = "invalid_format"
      expect { described_class.call(data:) }.to raise_error("Killer data not valid")
    end

    it "raises an error if victim data is invalid" do
      data["victim_id"] = "invalid_format"
      expect { described_class.call(data:) }.to raise_error("Victim data not valid")
    end
  end
end
