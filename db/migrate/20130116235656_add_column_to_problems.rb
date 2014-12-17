class AddColumnToProblems < ActiveRecord::Migration
  def change
		add_column :problems, :maker, :integer
  end
end
