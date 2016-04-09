class AddLockColumnToQuery < ActiveRecord::Migration
  def change
      add_column :queries, :is_lock, :boolean, default: false
  end
end
