require 'date'
def n_event_of_each_kind(n)
  events = {}
  gamelog_path = File.join(File.dirname(__FILE__), "game_log_large.txt")
  result_path = File.join(File.dirname(__FILE__), "#{n}_events_of_each_kind.txt")

  File.open(gamelog_path, "r") do |file|
    file.each_line do |line|
      data = line.strip.split
      kind = data[3]
      events[kind]  = [[DateTime.parse("#{data[0]} #{data[1]}"), line]] if events[kind].nil?
      events[kind] << [DateTime.parse("#{data[0]} #{data[1]}"), line] if events[kind].size < n
    end
  end

  event_lines = events.values.flatten(1).sort_by { |event| event[0] }.map { |event| event[1] }

  File.open(result_path, "w") do |file|
    event_lines.each do |line|
      file.puts line
    end
  end
end
