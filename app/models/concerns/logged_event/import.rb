class LoggedEvent::Import < BaseService
  def initialize(**kwargs)
    @filepath = kwargs[:filepath]
    @puts = kwargs[:puts] || false
  end

  private

  def run
    current_line = 1
    File.open(@filepath, "r") do |file|
      while (line = file.gets)
        splitted_line = line.strip.split(" ", 5)
        event_hash = {
            logged_at: "#{splitted_line[0]} #{splitted_line[1]}".to_datetime,
            context: splitted_line[2][1..-2],
            name: splitted_line[3],
            data: parse_key_value_pairs(splitted_line[4])
        }

        begin
          LoggedEvent::Handler.call(event_hash:) if LoggedEvent.create(event_hash)
          puts "Imported event from line #{current_line}" if @puts
        rescue NotImplementedError => e
        rescue StandardError => e
          Rails.logger.error("Failed to import event from line #{current_line}: #{e.message}")
        end
        current_line += 1
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
