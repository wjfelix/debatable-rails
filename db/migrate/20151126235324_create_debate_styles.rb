class CreateDebateStyles < ActiveRecord::Migration
  def change
    create_table :debate_styles do |t|

      t.string :debate_style, null: false
      t.timestamps
    end
  end
end
