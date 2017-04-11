class CreateSocietyPosts < ActiveRecord::Migration[5.0]
  def change
    create_table :society_posts do |t|
      
      t.text :body
      t.belongs_to :user
      t.belongs_to :society
      
      t.timestamps
    end
  end
end
