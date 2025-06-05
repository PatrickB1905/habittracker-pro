class CreateHabitEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :habit_entries do |t|
      t.references :habit, null: false, foreign_key: true
      t.date :completed_on, null: false

      t.timestamps
    end
    add_index :habit_entries, [:habit_id, :completed_on], unique: true
  end
end
