class AddPublicAndInProgressToFiretalks < ActiveRecord::Migration
  def change
    add_column :firetalks, :public, :boolean, :default => false
    add_column :firetalks, :in_progress, :boolean, :default => false
  end
end
