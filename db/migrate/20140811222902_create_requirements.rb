class CreateRequirements < ActiveRecord::Migration
  def change
    create_table :requirements do |t|
      t.references :project, index: true
      t.string :hashkey
      t.float :relative_starting_point
      t.float :relative_completeness
      t.text :description
      t.float :real_estimate
      t.float :real_effort
      t.boolean :for_experiment
      t.timestamps
      t.datetime :deleted_at
    end
    add_index :requirements, :deleted_at
  end
end
