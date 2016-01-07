class CreateFiretalkDebaters < ActiveRecord::Migration
  def change
    create_table :firetalk_debaters do |t|

      t.integer :points, null: false, default: 3
      t.string :position_description
      t.string :email, null: false
      t.timestamps
      t.references(:firetalk)
      t.references(:user)
    end
  end
end
