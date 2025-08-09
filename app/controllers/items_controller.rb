class ItemsController < ApplicationController
  def top
    @items = Query::TopItems.call
  end
end
