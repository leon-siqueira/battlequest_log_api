json.array! @players do |player|
  json.name player.name
  json.level player.level
  json.score player.score
  json.kills player.kills
  json.deaths player.deaths
  json.stats stats_url(player, format: :json)
end
