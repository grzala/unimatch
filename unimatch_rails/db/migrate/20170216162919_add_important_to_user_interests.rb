class AddImportantToUserInterests < ActiveRecord::Migration[5.0]
  def change
    add_column :user_interests, :important, :boolean, :default => false
  end
end
