class AddChapterToNote < ActiveRecord::Migration[5.1]
  def change
    add_reference :notes, :chapter, foreign_key: true
  end
end
