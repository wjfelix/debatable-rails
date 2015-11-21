class CreateDebates < ActiveRecord::Migration
  def change
    create_table :debates do |t|

      # Sports -> NFL, Politics -> Minimum Wage
      t.string :category, null: false
      t.string :topic, null: false

      t.string :name, null: false
      t.string :description
      t.string :type, null: false
      t.string :tok_session_id, null: false
      
      t.boolean :public, null: false, default: false
      t.timestamps
      t.references(:user)
    end
  end
end
