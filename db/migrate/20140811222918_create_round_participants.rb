class CreateRoundParticipants < ActiveRecord::Migration
  def change
    create_table :round_participants do |t|
      t.references :participant, index: true
      t.references :round, index: true
      t.float :effort_estimate
      t.string :justification
      t.timestamps
      t.datetime :deleted_at
    end
    add_index :round_participants, :deleted_at
  end
end
