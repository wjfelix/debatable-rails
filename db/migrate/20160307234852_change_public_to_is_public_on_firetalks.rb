class ChangePublicToIsPublicOnFiretalks < ActiveRecord::Migration
  def change
    rename_column :firetalks, :public, :is_public
  end
end
