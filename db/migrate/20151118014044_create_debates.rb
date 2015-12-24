class CreateDebates < ActiveRecord::Migration
  def change
    create_table :debates do |t|

      # Sports -> NFL, Politics -> Minimum Wage
      t.string :topic, null: false

      t.string :name, null: false
      t.string :description
      t.string :tok_session_id, null: false

      t.integer :size, null: false, default: 0
      t.boolean :public, null: false, default: false
      t.timestamps
      t.references(:user)
      t.references(:category)
      t.references(:debate_style)
    end
  end
end
