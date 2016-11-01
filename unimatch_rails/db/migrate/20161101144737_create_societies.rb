class CreateSocieties < ActiveRecord::Migration[5.0]
  def change
    create_table :societies do |t|
      t.string :name
      t.text :description
      t.float :cost
      t.boolean :paid
      t.boolean :recurring

      t.timestamps
    end
  end
end
