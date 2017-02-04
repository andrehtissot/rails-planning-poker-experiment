class CreateCompetences < ActiveRecord::Migration
  def change
    create_table :competences do |t|
      t.references :participant, index: true
      t.string :title
      t.integer :level
      t.timestamps
      t.datetime :deleted_at
    end
    add_index :competences, :deleted_at
  end
end
