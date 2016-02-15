class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|

      t.string :name, :default => "Anonymous"
      t.string :feedback_content, :null => false
      t.timestamps
    end
  end
end
