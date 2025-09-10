class AddCascadeDeleteToComments < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :comments, :posts
    add_foreign_key :comments, :posts, on_delete: :cascade
  end
end
