class CreateSocieties < ActiveRecord::Migration[5.0]
  def change
    create_table :societies do |t|
      t.string :name
      t.text :description, :default => ""
      t.boolean :paid, :default => false
      t.boolean :recurring, :default => false

      t.timestamps
    end
  end
end
