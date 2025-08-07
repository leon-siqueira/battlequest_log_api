class EventHandler::PlayerJoin < EventHandler::Base
  private

  def run
    player = Player.find_or_initialize_by(logged_id: @data["id"])
    player.assign_attributes(name: @data["name"], level: @data["level"])
    player.save!
  end
end
