json.data do
  json.array! @items do |item|
    json.rank item.rank
    json.name item.name.titleize
    json.total_quantity item.total_quantity
  end
end

json.partial! "layouts/meta", meta: @meta if @meta
