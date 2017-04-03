class CreateFavouriteUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :favourite_users do |t|
      
      t.references :user
      t.references :favourite

      t.timestamps
    end
  end
end
