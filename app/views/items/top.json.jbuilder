json.array! @items do |item|
  json.name item.name.titleize
  json.total_quantity item.total_quantity
end
