class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|

      t.boolean :seen
      t.timestamps
      t.references(:user)
    end
  end
end
