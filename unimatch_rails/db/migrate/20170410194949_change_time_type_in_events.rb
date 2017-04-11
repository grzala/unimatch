class ChangeTimeTypeInEvents < ActiveRecord::Migration[5.0]
  def change
    change_column :events, :time, :string
  end
end
