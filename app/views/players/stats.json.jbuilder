json.name @player.name
json.level @player.level
json.score @player.score
json.experience @player.xp
json.gold @player.gold
json.hp @player.hp
json.kills @player.kills
json.deaths @player.deaths
json.kdr @player.kdr
json.items_total @player.items_total_quantity
json.inventory do
  json.array! @player.items do |item|
    json.name item.name
    json.quantity item.quantity
  end
end
