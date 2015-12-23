class CreateModeratorInvites < ActiveRecord::Migration
  def change
    create_table :moderator_invites do |t|

      t.string :invite_message
      t.string :user_name
      t.timestamps
      t.references(:debate)
      t.references(:user)
    end
  end
end
