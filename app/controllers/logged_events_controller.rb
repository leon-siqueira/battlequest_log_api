class LoggedEventsController < ApplicationController
  def index
    @events = LoggedEvent.select(:context, :name, :data, :logged_at)
                         .order(logged_at: :desc)
                         .limit(params[:limit] || 100)
  end
end
