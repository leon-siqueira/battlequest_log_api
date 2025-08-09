class PlayersController < ApplicationController
  def index
    @players = Player.all
  end

  def stats
    @player = Query::PlayerStats.call(player_id: params[:id])
  end

  def leaderboard
    @players = Player.order(score: :desc).limit(10)
  end
end
