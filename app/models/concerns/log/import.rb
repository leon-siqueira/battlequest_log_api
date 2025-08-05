class Log::Import
  def initialize(**kwargs)
    # Rails.root.join("public", "example_log", "all_event_kinds.txt")
    @filepath = kwargs[:filepath]
    @events = {}
  end

  def self.call(**kwargs)
    new(**kwargs).call
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
            logged_at: "#{splitted_line[0]} #{splitted_line[1]}".to_datetime,
            context: splitted_line[2][1..-2],
            name: splitted_line[3],
            data: parse_key_value_pairs(splitted_line[4])
        }

        LoggedEvent.create!(event)
        # TODO: handle events i.e.: Reward player upon quest completion, PvP, loot, etc.
      end
    end
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

    result
  end
end
