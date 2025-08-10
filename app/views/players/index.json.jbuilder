json.data do
  json.array! @players, partial: "players/player_min", as: :player
end

json.partial! "layouts/meta", meta: @meta if @meta
