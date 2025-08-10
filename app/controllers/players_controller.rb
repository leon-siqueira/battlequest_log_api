class PlayersController < ApplicationController
  include HasMeta
  def index
    @players = Player.all

    @players = Query::Players.call(filters: params.permit(:name, :min_level, :max_level, :min_score, :min_kills),
                                   pagination: params.permit(:page, :per_page))

    set_sql_meta(Player, @players)
  end

  def stats
    @player = Query::PlayerStats.call(player_id: params[:id])
  end

  def leaderboard
    @players = Query::Leaderboard.call(filters: params.permit(:name, :min_level, :max_level, :min_score, :min_kills),
                                       pagination: params.permit(:page, :per_page))
    set_sql_meta(Player, @players)
  end
end
