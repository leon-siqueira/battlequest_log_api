json.data do
  json.array! @players do |player|
    json.rank player.rank
    json.name player.name
    json.level player.level
    json.score player.score
    json.kills player.kills
    json.deaths player.deaths
    json.stats stats_url(id: player.id, format: :json)
  end
end

json.partial! "layouts/meta", meta: @meta if @meta
