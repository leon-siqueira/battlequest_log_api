class EventHandler::Death < EventHandler::Base
  private

  def run
    killer = Player.find_or_initialize_by(logged_id: @data["killer_id"])
    killer.kills += 1
    killer.save!

    victim = Player.find_or_initialize_by(logged_id: @data["victim_id"])
    victim.deaths += 1
    victim.hp = 0
    victim.save!
  end
end
