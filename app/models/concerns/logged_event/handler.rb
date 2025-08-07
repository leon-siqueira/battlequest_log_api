class LoggedEvent::Handler < BaseService
  def initialize(**kwargs)
    @data = kwargs[:event_hash][:data]
    @event_name = kwargs[:event_hash][:name].split("_").map(&:capitalize).join
  end

  private

  def run
    raise NotImplementedError, "Event #{@event_name} handling not implemented" unless Object.const_defined?("EventHandler::#{@event_name}")
    object = Object.const_get("EventHandler::#{@event_name}").new
    raise NotImplementedError, "Event EventHandler::#{@event_name} is not a valid EventHandler" unless object.is_a?(EventHandler::Base)
    Object.const_get("EventHandler::#{@event_name}").call(data: @data)
  end
end
