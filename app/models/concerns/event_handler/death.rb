class EventHandler::Death < EventHandler::Base
  private

  def run
    killer = Player.find_or_initialize_by(logged_id: @data["killer_id"])
    killer.kills += 1

    victim = Player.find_or_initialize_by(logged_id: @data["victim_id"])
    victim.deaths += 1
    victim.hp = 0

    raise "Killer data not valid" unless killer.valid?
    raise "Victim data not valid" unless victim.valid?

    killer.save!(validate: false)
    victim.save!(validate: false)
  end
end
