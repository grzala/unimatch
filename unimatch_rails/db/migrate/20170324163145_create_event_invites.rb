class CreateEventInvites < ActiveRecord::Migration[5.0]
  def change
    create_table :event_invites do |t|

      t.references :sender
      t.references :recipient
      t.belongs_to :event

      t.timestamps
    end
  end
end
