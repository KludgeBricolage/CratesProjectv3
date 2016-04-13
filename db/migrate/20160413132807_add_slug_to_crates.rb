class AddSlugToCrates < ActiveRecord::Migration
  def change
    add_column :crates, :slug, :string
    add_index :crates, :slug, unique: true
  end
end
