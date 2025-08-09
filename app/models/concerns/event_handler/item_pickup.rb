class EventHandler::ItemPickup < EventHandler::Base
  private

  def run
    player = Player.find_or_initialize_by(logged_id: @data["player_id"])
    item = Item.find_or_initialize_by(name: @data["item"])
    raise "Item data not valid" unless item.valid?
    raise "Player data not valid" unless player.valid?

    item.save!(validate: false) if item.new_record?
    player.save!(validate: false) if player.new_record?
    PlayerItem.create!(player:, item:, quantity: @data["qty"].to_i)
  end
end
