class EventHandler::BossDefeat < EventHandler::Base
  private

  def run
    player = Player.find_or_initialize_by(logged_id: @data["defeated_by"])
    player.xp += @data["xp"].to_i
    player.gold += @data["gold"].to_i
    player.save!
  end
end
