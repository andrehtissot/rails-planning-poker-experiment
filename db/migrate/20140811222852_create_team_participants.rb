class CreateTeamParticipants < ActiveRecord::Migration
  def change
    create_table :team_participants do |t|
      t.references :participant, index: true
      t.references :team, index: true
      t.timestamps
      t.datetime :deleted_at
    end
    add_index :team_participants, :deleted_at
  end
end
