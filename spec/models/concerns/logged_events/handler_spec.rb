require 'rails_helper'

class EventHandler::DefinedEvent < EventHandler::Base; def run; "Handling DefinedEvent"; end; end
class EventHandler::InvalidEvent < BaseService; end

RSpec.describe LoggedEvent::Handler do
  let(:event_hash) do
    {
      logged_at: Time.now,
      context: "test_context",
      name: "DEFINED_EVENT",
      data: { "id" => "p123", "name" => "Test Player", "level" => 1 }
    }
  end

  describe ".call" do
    it "calls the appropriate event handler" do
      expect(described_class.call(event_hash:)).to eq("Handling DefinedEvent")
    end

    it "raises NotImplementedError if the event handler is not defined" do
      event_hash[:name] = "NON_DEFINED_EVENT"
      expect { described_class.call(event_hash:) }.to raise_error { |error|
        expect(error).to be_a(NotImplementedError)
        expect(error.message).to eq("Event NonDefinedEvent handling not implemented")
      }
    end

    it "raises NotImplementedError if the event handler is not a valid EventHandler" do
      event_hash[:name] = "INVALID_EVENT"
      expect { described_class.call(event_hash:) }.to raise_error { |error|
        expect(error).to be_a(NotImplementedError)
        expect(error.message).to eq("Event EventHandler::InvalidEvent is not a valid EventHandler")
      }
    end
  end
end
