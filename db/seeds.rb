files = {
  1 => "1_event_of_each_kind.txt",
  2 => "10_events_of_each_kind.txt",
  3 => "100_events_of_each_kind.txt",
  4 => "game_log_large.txt"
}

file = false

while !file
  system "clear"
  puts "Which file do you want to import?"
  files.each do |key, value|
    puts "#{key} - #{value}"
  end

  input = gets.chomp.to_i

  if files.key?(input)
    file = files[input]
  else
    system "clear"
    puts "Invalid option. Please try again."
    sleep 2
  end
end
system "clear"

LoggedEvent::Import.call(filepath: Rails.root.join("public", "example_log", file), puts: true)
