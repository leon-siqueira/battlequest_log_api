class Query::Players < BaseService
  include Query::Filters::PlayerFilters

  def initialize(**kwargs)
    @filters = kwargs[:filters] || {}
    @pagination = kwargs[:pagination]
  end

  private
  def run
    filters(skip_where: true)
    Player.where([ @where_clause, @values ]).page(@pagination[:page].to_i.abs.nonzero? || 1)
                         .per([ @pagination[:per_page].to_i.abs.nonzero? || 5, 100 ].min)
  end
end
