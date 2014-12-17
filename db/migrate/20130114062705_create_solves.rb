class CreateSolves < ActiveRecord::Migration
  def change
    create_table :solves do |t|
      t.integer :uid
      t.integer :pid

      t.timestamps
    end
  end
end
