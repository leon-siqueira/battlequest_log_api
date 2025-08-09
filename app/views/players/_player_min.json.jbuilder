json.extract! player, :name, :level, :score
json.stats stats_url(player, format: :json)
