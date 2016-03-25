class CreateFiretalkMessages < ActiveRecord::Migration
  def change
    create_table :firetalk_messages do |t|

      t.string :name
      t.string :content, :default => ""
      t.timestamps
      t.references(:firetalk)
    end
  end
end
