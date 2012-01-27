class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :name
      t.boolean :sex
      t.date :birthdate
      t.references :user

      t.timestamps
    end
    add_index :profiles, :user_id
  end
end
