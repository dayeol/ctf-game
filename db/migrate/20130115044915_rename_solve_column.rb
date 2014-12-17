class RenameSolveColumn < ActiveRecord::Migration
  def self.up
		rename_column :solves, :uid, :user_id
		rename_column :solves, :pid, :problem_id
  end

  def self.down
  end
end
