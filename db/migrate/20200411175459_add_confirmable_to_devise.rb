class AddConfirmableToDevise < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string # Only if using reconfirmable
    add_index :users, :confirmation_token, unique: true
    # users as confirmed, do the following
    execute("UPDATE users SET confirmed_at = NOW()")
    # All existing user accounts should be able to log in after this.
  end

  def down
    remove_columns :users, :confirmation_token, :confirmed_at, :confirmation_sent_at
    remove_columns :users, :unconfirmed_email # Only if using reconfirmable
  end
end
