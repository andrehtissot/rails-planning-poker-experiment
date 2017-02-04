class CreateEstimates < ActiveRecord::Migration
  def change
    create_table :estimates do |t|
      t.references :team, index: true
      t.references :requirement, index: true
      t.float :effort_estimate
      t.text :justification
      t.timestamps
      t.datetime :deleted_at
    end
    add_index :estimates, :deleted_at
  end
end
