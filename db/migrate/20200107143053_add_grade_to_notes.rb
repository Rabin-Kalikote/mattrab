class AddGradeToNotes < ActiveRecord::Migration[5.1]
  def change
    add_column :notes, :grade, :integer, default: 0
  end
end
