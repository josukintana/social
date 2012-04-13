class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :text_comment_title
      t.text :text_comment
      t.string :img_file_name
      t.string :img_content_type
      t.integer :img_file_size
      t.datetime :img_updated_at
      t.string :src_url
      t.string :user_fullname
      t.integer :user_id

      t.timestamps
    end
  end
end
