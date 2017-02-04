class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.string :hashkey
      t.string :objective
      t.string :technologies
      t.integer :size
      t.timestamps
      t.datetime :deleted_at
    end
    add_index :projects, :deleted_at
  end
end
