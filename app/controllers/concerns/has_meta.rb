module HasMeta
  private
  def set_sql_meta(klass, list, url_method)
    page = params[:page].to_i.abs.nonzero? || 1
    per_page = params[:per_page].to_i.abs.nonzero? || 5
    next_page = page * per_page < klass.count
    prev_page = page > 1
    @meta = {
      current_page: page,
      total_pages: (klass.count / per_page.to_f).ceil,
      next_url: next_page ? url_method.call(page: page + 1, per_page:, format: :json) : nil,
      prev_url: prev_page ? url_method.call(page: page - 1, per_page:, format: :json) : nil
    }
  end

  def set_kaminari_meta(list, url_method)
    @meta = {
      current_page: list.current_page,
      total_pages: list.total_pages,
      next_url: list.next_page ? url_method.call(page: list.next_page, per_page: list.limit_value, format: :json) : nil,
      prev_url: list.prev_page ? url_method.call(page: list.prev_page, per_page: list.limit_value, format: :json) : nil
    }
  end
end
