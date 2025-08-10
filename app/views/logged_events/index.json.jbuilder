json.data do
  json.array! @events, partial: "logged_events/event", as: :event
end

json.partial! "layouts/meta", meta: @meta if @meta
