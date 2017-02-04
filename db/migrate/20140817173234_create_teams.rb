class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.datetime :deleted_at
      t.timestamps
    end
    add_index :teams, :deleted_at
  end
end
