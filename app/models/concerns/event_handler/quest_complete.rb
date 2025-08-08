class EventHandler::QuestComplete < EventHandler::Base
  private

  def run
    player = Player.find_or_initialize_by(logged_id: @data["player_id"])
    quest = Quest.find_or_initialize_by(logged_id: @data["quest_id"])

    raise "Quest data not valid" unless quest.valid?
    raise "Player data not valid" unless player.valid?

    quest.save! if quest.new_record?
    player.xp += @data["xp"].to_i
    player.gold += @data["gold"].to_i
    player.save!

    player_quest = PlayerQuest.find_or_initialize_by(player:, quest:)
    player_quest.update!(status: "completed")
  end
end
