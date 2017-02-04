class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.references :estimate, index: true
      t.integer :number
      t.timestamps
      t.datetime :deleted_at
    end
    add_index :rounds, :deleted_at
  end
end
