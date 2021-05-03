class AddFeedbackToNotes < ActiveRecord::Migration[5.1]
  def change
    add_column :notes, :feedback, :string
  end
end
