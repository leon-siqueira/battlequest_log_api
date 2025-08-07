class EventHandler::Base < BaseService
  def initialize(**kwargs)
    @data = kwargs[:data]
  end
end
