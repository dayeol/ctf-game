class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.string :name
      t.string :category
      t.integer :point
      t.string :key
      t.string :hint

      t.timestamps
    end
  end
end
