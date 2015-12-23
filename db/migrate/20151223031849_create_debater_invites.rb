class CreateDebaterInvites < ActiveRecord::Migration
  def change
    create_table :debater_invites do |t|

      t.string :invite_message
      t.string :user_name
      t.timestamps
      t.references(:debate)
      t.references(:user)
    end
  end
end
