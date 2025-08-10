QueriedPlayer = Struct.new(:name, :level, :score, :kills, :deaths, :rank, :id)

class Query::Leaderboard < BaseService
  include Query::Filters::PlayerFilters

  def initialize(**kwargs)
    @filters = kwargs[:filters] || {}
    @pagination = kwargs[:pagination]
  end

  private

  def run
    ActiveRecord::Base.connection.execute(
      ActiveRecord::Base.send(:sanitize_sql_array, [ query, @values ])
      ).map do |row|
      QueriedPlayer.new(row["name"], row["level"], row["score"], row["kills"], row["deaths"], row["rank"], row["id"])
    end
  end

  def query
    filters
    limit = [ @pagination[:per_page].to_i.abs.nonzero? || 5, 100 ].min
    offset = ((@pagination[:page].to_i.abs.nonzero? || 1) - 1) * limit

    <<-SQL
      WITH ranked_players AS (
        SELECT name,
               level,
               score,
               kills,
               deaths,
               RANK() OVER (ORDER BY score DESC) AS rank,
               id
        FROM players
      )
      SELECT *
      FROM ranked_players
      #{@where_clause if @where_clause}
      LIMIT #{limit} OFFSET #{offset};
    SQL
  end
end
