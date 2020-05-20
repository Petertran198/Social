class AddPostToComments < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :post, :string
  end
end
