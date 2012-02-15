class CreateFollowments < ActiveRecord::Migration
  def change
    create_table :followments do |t|
      t.references :user
      t.references :followed

      t.timestamps
    end
    add_index :followments, :user_id
    add_index :followments, :followed_id
  end
end
