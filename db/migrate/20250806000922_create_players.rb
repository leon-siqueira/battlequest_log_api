class CreatePlayers < ActiveRecord::Migration[7.2]
  def change
    create_table :players do |t|
      t.string :logged_id, null: false
      t.string :name, default: ""
      t.integer :level, default: 1
      t.integer :gold, null: false, default: 0
      t.integer :xp, null: false, default: 0
      t.integer :hp, null: false, default: 0

      t.timestamps
    end

    add_index :players, :logged_id, unique: true
  end
end
