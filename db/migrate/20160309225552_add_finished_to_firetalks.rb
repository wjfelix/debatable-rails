class AddFinishedToFiretalks < ActiveRecord::Migration
  def change
    add_column :firetalks, :finished, :boolean, :default => false
  end
end
