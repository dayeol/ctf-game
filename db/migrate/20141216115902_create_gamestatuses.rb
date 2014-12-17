class CreateGamestatuses < ActiveRecord::Migration
  def change
    create_table :gamestatuses do |t|
      t.timestamps
      t.string :status
    end
  end
end
