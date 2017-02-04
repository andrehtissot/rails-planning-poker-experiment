class AddAccessLogIdToBrowserLog < ActiveRecord::Migration
  def change
    add_column :browser_logs, :access_log_id, :long
  end
end
