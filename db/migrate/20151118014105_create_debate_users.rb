class CreateDebateUsers < ActiveRecord::Migration
  def change
    create_table :debate_users do |t|

      t.boolean :is_judge, null: false, default: false
      t.boolean :is_connected, null: false, default: false
      t.string :position_description
      t.string :tok_session
      t.integer :level, null: false, default: 0
      t.timestamps
      t.references(:debate)
    end
  end
end
