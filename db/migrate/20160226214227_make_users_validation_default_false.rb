class MakeUsersValidationDefaultFalse < ActiveRecord::Migration
  def change
    change_column :users, :is_validated, :boolean, :default => false
  end
end
