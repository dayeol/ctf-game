class AddFileToProblems < ActiveRecord::Migration
  def change
    add_column :problems, :file, :string
  end
end
