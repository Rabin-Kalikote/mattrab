class AddIsVerifiedToNotes < ActiveRecord::Migration[5.1]
  def change
    add_column :notes, :is_verified, :boolean, default: false
  end
end
