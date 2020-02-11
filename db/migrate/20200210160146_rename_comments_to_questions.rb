class RenameCommentsToQuestions < ActiveRecord::Migration[5.1]
  def change
    rename_table :comments, :questions
  end
end
