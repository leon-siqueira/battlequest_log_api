class LoggedEventsController < ApplicationController
  include HasMeta

  def index
    limit = [ params.permit[:per_page].to_i.nonzero? || 25, 200 ].min
    offset = (params.permit[:page].to_i.nonzero? || 1 - 1) * limit
    @events = LoggedEvent.select(:context, :name, :data, :logged_at)
                         .order(logged_at: :desc).limit(limit).offset(offset)
    set_sql_meta(LoggedEvent, @events, ->(params) { logged_events_url(params) })
  end
end
