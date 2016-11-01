class CreateBillingHistories < ActiveRecord::Migration[5.0]
  def change
    create_table :billing_histories do |t|
      t.date :date
      t.float :amount

      t.belongs_to :society
      
      t.timestamps
    end
  end
end
