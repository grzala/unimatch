class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.integer  :user_id
      t.string   :subject
      t.string   :body
      t.boolean  :sent
      t.timestamps
    end
  end
end
