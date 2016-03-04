class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|

      t.string :email
      t.string :from
      t.string :message
      t.string :path
      t.boolean :is_seen, default: false

      t.timestamps
      t.references(:user)
    end
  end
end
