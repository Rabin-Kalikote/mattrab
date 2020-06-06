class RenameUserColumnsName < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :grade, :egrade
  end
end
