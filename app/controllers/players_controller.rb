class PlayersController < ApplicationController
  def index
    @players = Player.all
  end

  def stats
    sql = <<-SQL
      SELECT
        players.*,
        SUM(player_items.quantity) AS total_quantity,
        (
          SELECT
            array_agg(
              json_build_object(
                'name', items.name,
                'quantity', pi.total_quantity
              )
            )
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

    @player = Player.find_by_sql([ sql, { id: params[:id] } ]).first
    @items = @player.inventory || []
  end

  def leaderboard
    @players = Player.order(score: :desc).limit(10)
  end
end
