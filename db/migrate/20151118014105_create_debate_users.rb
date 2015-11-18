class CreateDebateUsers < ActiveRecord::Migration
  def change
    create_table :debate_users do |t|

      t.boolean :is_judge, null: false, default: false
      t.string :position_description
      t.integer :level, null: false, default: 0
      t.timestamps
      t.foreign_key(:debates)
    end
  end
end
