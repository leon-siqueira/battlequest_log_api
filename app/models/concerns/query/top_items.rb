QueriedItem = Struct.new(:name, :total_quantity, :rank)

class Query::TopItems < BaseService
  def initialize(**kwargs)
    @filters = kwargs[:filters] || {}
    @pagination = kwargs[:pagination]
  end

  private

  def run
    ActiveRecord::Base.connection.execute(
      ActiveRecord::Base.send(:sanitize_sql_array, [ query, @values ])
      ).map do |row|
      QueriedItem.new(row["name"], row["total_quantity"], row["rank"])
    end
  end

  def query
    filters
    limit = [ @pagination[:per_page].to_i.abs.nonzero? || 5, 100 ].min
    offset = ((@pagination[:page].to_i.abs.nonzero? || 1) - 1) * limit

    <<-SQL
      WITH ranked_items AS (
        SELECT
        items.name,
        SUM(player_items.quantity) AS total_quantity,
        RANK() OVER (ORDER BY SUM(player_items.quantity) DESC) AS rank
        FROM
          items
        JOIN
          player_items ON items.id = player_items.item_id
        GROUP BY
          items.name
        ORDER BY
          rank
      )
      SELECT
        *
      FROM
        ranked_items
      #{@where_clause if @where_clause}
      LIMIT #{limit} OFFSET #{offset};
    SQL
  end

  def filters
    conditions = []
    @values = {}
    return if @filters.empty?

    @filters.to_h.each do |key, value|
      case key
      when "name"
        conditions << "name LIKE :name"
        @values[:name] = "%#{value}%"
      when "lt"
        conditions << "total_quantity < :lt"
        @values[:lt] = value.to_i
      when "lte"
        conditions << "total_quantity <= :lte"
        @values[:lte] = value.to_i
      when "gt"
        conditions << "total_quantity > :gt"
        @values[:gt] = value.to_i
      when "gte"
        conditions << "total_quantity >= :gte"
        @values[:gte] = value.to_i
      when "eq"
        conditions << "total_quantity = :eq"
        @values[:eq] = value.to_i
      else
        ""
      end
    end

    @where_clause = conditions.join(" AND ").prepend("WHERE ") unless conditions.empty?
  end
end
