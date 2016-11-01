class CreateInterestGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :interest_groups do |t|
      t.belongs_to :interests
      t.string :name

      t.timestamps
    end
  end
end
