class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password, :string
	add_column :users, :point, :int
  end
end
