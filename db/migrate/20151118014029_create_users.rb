class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

      t.string :firstname, null: false
      t.string :lastname, null: false
      t.string :email, null: false, unique: true
      t.string :school, null: false
      t.string :password_digest, null: false
      t.boolean :is_validated, null: false, default: false
      t.string :validation_code, null: false
      t.integer :level, null: false, default: 0
      t.timestamps
    end
  end
end
