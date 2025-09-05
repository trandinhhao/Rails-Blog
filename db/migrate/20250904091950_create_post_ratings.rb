class CreatePostRatings < ActiveRecord::Migration[8.0]
  def change
    create_table :post_ratings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.integer :star

      t.timestamps
    end
  end
end
