class CreateDebateInvites < ActiveRecord::Migration
  def change
    create_table :debate_invites do |t|

      t.string :invite_email, null: false
      t.string :invite_message
      t.references :debate
      t.timestamps
    end
  end
end
