class AddScoreToPlayers < ActiveRecord::Migration[7.2]
  def change
    add_column :players, :score, :integer, null: false, default: 0
  end
end
