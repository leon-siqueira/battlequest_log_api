class Log::Read
  def initialize
    @filepath = Rails.root.join("public", "example_log", "game_log_large.txt")
    @events = {}
  end

  def self.call
    new.call
  end

  def call
    run
  end

  private

  def run
        File.open(@filepath, "r") do |file|
          while (line = file.gets)
            splitted_line = line.strip.split(" ", 5)
            event = {
                timestamp: "#{splitted_line[0]} #{splitted_line[1]}",
                type: splitted_line[2],
                name: splitted_line[3],
                data: splitted_line[4]
            }
            @events[event[:name]] = parse_key_value_pairs(event[:data]) unless @events.key?(event[:name])
          end
        end

        p @events
  end

  def parse_key_value_pairs(data)
    result = {}

    pattern = /([^=\s]+)=(?:"([^"]*)"|([^"\s]+))/

    data.scan(pattern) do |key, quoted_value, non_quoted_value|
      value = quoted_value.nil? ? non_quoted_value : quoted_value

      if value =~ /\A\d+\z/
        value = value.to_i
        result[key] = value; next
      end

      if value =~ /\A\(\d+,\d+\)\z/
        result[key] = value.gsub(/[()]/, "").split(",").map(&:to_i); next
      end

      result[key] = value
    end

    JSON.generate(result)
  end
end
