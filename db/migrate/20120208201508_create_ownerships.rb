class CreateOwnerships < ActiveRecord::Migration
  def change
    create_table :ownerships do |t|
      t.references :user
      t.references :group

      t.timestamps
    end
    add_index :ownerships, :user_id
    add_index :ownerships, :group_id
  end
end
