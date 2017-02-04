class CreateBrowserLogs < ActiveRecord::Migration
  def change
    create_table :browser_logs do |t|
      t.text :header_json, :limit => 4294967295
      t.text :event_json, :limit => 4294967295
      t.timestamps
    end
  end
end
