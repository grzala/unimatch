class AddTypeToNotification < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :notif_type, :string
  end
end
