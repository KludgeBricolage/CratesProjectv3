class ChangeLongLatColumnOfLocation < ActiveRecord::Migration
  def change
      change_column :locations, :long, :string
      change_column :locations, :lat, :string
      remove_column :locations, :place_id
  end
end
