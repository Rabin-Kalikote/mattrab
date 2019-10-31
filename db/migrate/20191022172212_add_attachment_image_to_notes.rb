class AddAttachmentImageToNotes < ActiveRecord::Migration[5.1]
  def self.up
    change_table :notes do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :notes, :image
  end
end
