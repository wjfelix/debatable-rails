class AddFullToFiretalks < ActiveRecord::Migration
  def change
    add_column :firetalks, :full, :boolean, :default => false
  end
end
