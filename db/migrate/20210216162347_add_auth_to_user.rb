class AddAuthToUser < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :uid, :string, default: ''
    add_column :users, :avatar_url, :string, default: ''
  end

  def down
    remove_columns :users, :uid, :avatar_url
  end
end
