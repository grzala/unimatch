class AddAvatarToSocieties < ActiveRecord::Migration[5.0]
  def change
    add_column :societies, :avatar, :string
  end
end
