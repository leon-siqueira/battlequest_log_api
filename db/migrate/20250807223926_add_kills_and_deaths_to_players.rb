class AddKillsAndDeathsToPlayers < ActiveRecord::Migration[7.2]
  def change
    add_column :players, :kills, :integer, null: false, default: 0
    add_column :players, :deaths, :integer, null: false, default: 0
  end
end
