class CreatePlayerQuests < ActiveRecord::Migration[7.2]
  def change
    create_table :player_quests do |t|
      t.references :player, null: false, foreign_key: true
      t.references :quest, null: false, foreign_key: true
      t.string :status, null: false, default: ""

      t.timestamps
    end
  end
end
