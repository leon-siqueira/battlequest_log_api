class CreateLoggedEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :logged_events do |t|
      t.timestamp :logged_at
      t.string :context
      t.string :name
      t.json :data

      t.timestamps
    end
  end
end
