class CreateWallevents < ActiveRecord::Migration
  def change
    create_table :wallevents do |t|
      t.integer :wall_id
      t.integer :activity_id

      t.timestamps
    end
  end
end
