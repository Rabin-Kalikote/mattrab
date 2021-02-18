class DropActsAsTaggable < ActiveRecord::Migration[5.1]
  def change
    drop_table :tags do |t|
      t.string :name
      t.integer :taggings_count, default: 0
    end

    drop_table :taggings do |t|
      t.references :tag

      # You should make sure that the column created is
      # long enough to store the required class names.
      t.references :taggable, polymorphic: true
      t.references :tagger, polymorphic: true

      # Limit is created to prevent MySQL error on index
      # length for MyISAM table type: http://bit.ly/vgW2Ql
      t.string :context, limit: 128

      t.datetime :created_at
    end
  end
end
