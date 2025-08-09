InventoryItem = Struct.new(:name, :quantity)
QueriedPlayer = Struct.new(
  :logged_id, :name, :level, :score, :hp, :xp, :gold,
  :kills, :deaths, :items_total_quantity, :inventory
) do
  def items
    JSON.parse(inventory).map { |item| InventoryItem.new(item["name"], item["quantity"]) }
  end

  def kdr
    (kills.to_f / deaths.nonzero? || 1).round(2) # TODO: centralize this logic
  end
end

class Query::PlayerStats < BaseService
  def initialize(**args)
    @player_id = args[:player_id]
  end

  private

  def run
    @player_data = ActiveRecord::Base.connection.execute(
      ActiveRecord::Base.send(:sanitize_sql_array, [ query, { id: @player_id } ])
    ).first

    raise ActiveRecord::RecordNotFound, "Player not found" unless @player_data

    @player = QueriedPlayer.new(
      @player_data["logged_id"],
      @player_data["name"],
      @player_data["level"],
      @player_data["score"],
      @player_data["hp"],
      @player_data["xp"],
      @player_data["gold"],
      @player_data["kills"],
      @player_data["deaths"],
      @player_data["items_total_quantity"],
      @player_data["inventory"] || "[]"
    )
  end

  def query
    <<-SQL
      SELECT
        players.logged_id,
        players.name,
        players.level,
        players.score,
        players.hp,
        players.xp,
        players.gold,
        players.score,
        players.kills,
        players.deaths,
        SUM(player_items.quantity) AS items_total_quantity,
        (
          SELECT
            '[' ||
            array_to_string(
              array_agg
              (
                json_build_object
                (
                  'name', items.name,
                  'quantity', pi.total_quantity
                )
              )
            , ', ') ||
            ']' AS inventory
          FROM (
            SELECT
              item_id,
              SUM(quantity) as total_quantity
            FROM
              player_items
            WHERE
              player_id = players.id
            GROUP BY
              item_id
          ) pi
          JOIN items ON items.id = pi.item_id
        ) AS inventory
      FROM
        players
      LEFT JOIN player_items ON player_items.player_id = players.id
      WHERE
        players.id = :id
      GROUP BY
        players.id
      LIMIT 1
    SQL
  end
end
