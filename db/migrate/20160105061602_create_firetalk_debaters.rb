class CreateFiretalkDebaters < ActiveRecord::Migration
  def change
    create_table :firetalk_debaters do |t|

      t.integer :points, null: false, default: 0
      t.string :position_description
      t.timestamps
      t.references(:firetalk)
      t.references(:user)
    end
  end
end
