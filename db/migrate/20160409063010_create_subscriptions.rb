class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
        t.references :user, index: true, foreign_key: true
        t.references :forum_post, index: true, foreign_key: true
        t.timestamps null: true
    end
  end
end
