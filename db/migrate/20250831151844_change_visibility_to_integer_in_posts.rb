class ChangeVisibilityToIntegerInPosts < ActiveRecord::Migration[8.0]
  def change
    change_column :posts, :visibility, :integer, using: 'visibility::integer'
  end
end
