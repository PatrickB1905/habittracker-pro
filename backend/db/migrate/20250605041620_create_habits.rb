class CreateHabits < ActiveRecord::Migration[8.0]
  def change
    create_table :habits do |t|
      t.string :title, null: false
      t.text :description
      t.string :frequency, null: false
      t.boolean :public, default: false, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
