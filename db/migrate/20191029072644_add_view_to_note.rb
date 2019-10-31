class AddViewToNote < ActiveRecord::Migration[5.1]
  def change
    add_column :notes, :view, :int, default: 0
  end
end
