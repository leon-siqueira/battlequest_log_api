class ItemsController < ApplicationController
  include HasMeta
  def top
    @items = Query::TopItems.call(filters: params.permit(:name, :lt, :lte, :gt, :gte, :eq),
                                  pagination: params.permit(:page, :per_page))
    set_sql_meta(Item, @items, ->(params) { top_items_url(params) })
  end
end
