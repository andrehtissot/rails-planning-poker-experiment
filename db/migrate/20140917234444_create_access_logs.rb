class CreateAccessLogs < ActiveRecord::Migration
  def change
    create_table :access_logs do |t|
      t.text :header_json, :limit => 4294967295
      t.text :session_json, :limit => 4294967295
      t.string :controller
      t.string :action
      t.text :params, :limit => 4294967295
      t.timestamps
    end
  end
end
