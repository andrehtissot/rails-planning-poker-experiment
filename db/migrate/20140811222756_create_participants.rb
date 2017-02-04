class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.string :name
      t.date :birthday
      t.string :function
      t.integer :sex
      t.integer :original_participant_id
      t.timestamps
      t.datetime :deleted_at
    end
    add_index :participants, :deleted_at
  end
end
