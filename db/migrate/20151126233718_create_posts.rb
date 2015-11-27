class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :endorsements
      t.timestamps
      t.references(:user)
    end
  end
end
