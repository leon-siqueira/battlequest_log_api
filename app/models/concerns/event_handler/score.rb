class EventHandler::Score < EventHandler::Base
  private

  def run
    player = Player.find_or_initialize_by(logged_id: @data["player_id"])
    player.score += @data["score"].to_i
    player.save!
  end
end
