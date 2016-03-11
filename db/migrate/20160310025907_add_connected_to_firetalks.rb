class AddConnectedToFiretalks < ActiveRecord::Migration
  def change
    add_column :firetalks, :connected, :integer, :default => 0
  end
end
