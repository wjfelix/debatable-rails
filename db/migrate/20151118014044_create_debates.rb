class CreateDebates < ActiveRecord::Migration
  def change
    create_table :debates do |t|

      t.integer :owner_id, null: false
      t.string :topic, null: false
      t.string :type, null: false
      t.string :tok_session_id, null: false
      t.boolean :public, null: false, default: false
      t.timestamps
      t.foreign_key(:users)
    end
  end
end
