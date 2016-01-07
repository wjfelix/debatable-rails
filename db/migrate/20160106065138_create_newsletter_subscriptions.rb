class CreateNewsletterSubscriptions < ActiveRecord::Migration
  def change
    create_table :newsletter_subscriptions do |t|

      t.string :email, null: false
      t.timestamps
    end
  end
end
