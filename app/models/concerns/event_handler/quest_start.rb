class EventHandler::QuestStart < EventHandler::Base
  private

  def run
    player = Player.find_or_initialize_by(logged_id: @data["player_id"])
    quest = Quest.find_or_initialize_by(logged_id: @data["quest_id"])
    raise "Quest data not valid" unless quest.valid?
    raise "Player data not valid" unless player.valid?

    player.save!
    quest.save!

    PlayerQuest.find_or_create_by!(player:, quest:) { |pq| pq.status = "started" }
  end
end
