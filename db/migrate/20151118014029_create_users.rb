class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

      t.string :firstname, null: false
      t.string :lastname, null: false

      t.string :email, null: false, unique: true
      t.string :school
      t.string :password_digest, null: false
      t.boolean :is_validated, null: false, default: true
      t.string :validation_code
      t.integer :level, null: false, default: 0
      t.timestamps
    end
  end
end
