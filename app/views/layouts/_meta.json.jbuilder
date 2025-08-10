json.meta do
  json.current_page @meta[:current_page]
  json.total_pages @meta[:total_pages]
  json.prev_page @meta[:prev_url] if @meta[:prev_url]
  json.next_page @meta[:next_url] if @meta[:next_url]
end
