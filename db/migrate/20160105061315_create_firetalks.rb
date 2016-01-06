class CreateFiretalks < ActiveRecord::Migration
  def change
    create_table :firetalks do |t|

      t.string :topic, null: false

      t.string :name, null: false
      t.string :description
      t.integer :rounds, null: false, default: 4
      t.integer :seconds, null: false
      t.timestamps
      t.references(:user)
      t.references(:category)
    end
  end
end
