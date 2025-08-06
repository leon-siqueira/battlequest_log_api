class CreateQuests < ActiveRecord::Migration[7.2]
  def change
    create_table :quests do |t|
      t.string :logged_id, null: false
      t.string :name, null: false, default: ""
      t.integer :xp, null: false, default: 0
      t.integer :gold, null: false, default: 0

      t.timestamps
    end
  end
end
