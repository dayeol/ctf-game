class CreatePenalties < ActiveRecord::Migration
  def change
    create_table :penalties do |t|
      t.timestamps
      t.integer :giver_id
      t.integer :user_id
      t.integer :percentage
    end
  end
end
