class CreateEventPosts < ActiveRecord::Migration[5.0]
  def change
    create_table :event_posts do |t|
      
      t.text :body
      t.belongs_to :user
      t.belongs_to :eventsociety

      t.timestamps
    end
  end
end
