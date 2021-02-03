class AddChapterToQuestion < ActiveRecord::Migration[5.1]
  def change
    add_reference :questions, :chapter, foreign_key: true
  end
end
