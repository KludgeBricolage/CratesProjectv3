class CreateForumCategories < ActiveRecord::Migration
  def change
    create_table :forum_categories do |t|
      t.string :name
      t.timestamps null: true
    end
  end
end
