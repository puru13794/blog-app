class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :thumbnail
      t.integer :category
      t.integer :user_id
      t.string :description

      t.timestamps
    end
  end
end
