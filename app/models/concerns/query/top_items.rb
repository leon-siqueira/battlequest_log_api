QueriedItem = Struct.new(:name, :total_quantity)

class Query::TopItems < BaseService
  private

  def run
    ActiveRecord::Base.connection.execute(query).map do |row|
      QueriedItem.new(row["name"], row["total_quantity"])
    end
  end

  def query
    <<-SQL
      SELECT
        items.name,
        SUM(player_items.quantity) AS total_quantity
      FROM
        items
      JOIN
        player_items ON items.id = player_items.item_id
      GROUP BY
        items.id
      ORDER BY
        total_quantity DESC
      LIMIT 10;
    SQL
  end
end
