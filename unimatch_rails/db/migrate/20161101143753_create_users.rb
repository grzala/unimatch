class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :surname
      t.string :hashed_password
      t.string :salt
      
      #t.belongs_to :university, index: true #after we add some universities. add same in societies
      
      t.timestamps
    end
  end
end
