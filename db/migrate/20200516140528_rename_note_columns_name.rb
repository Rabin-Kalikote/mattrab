class RenameNoteColumnsName < ActiveRecord::Migration[5.1]
  def change
    rename_column :notes, :grade, :egrade
    rename_column :notes, :category, :ecategory
  end
end
