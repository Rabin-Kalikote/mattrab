class Chapter < ApplicationRecord
  validates :name, presence: true
  belongs_to :category
  has_many :notes
  has_many :questions

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      category = find_by_id(row["id"]) || new
      category.attributes = row.to_hash.slice("name", "category_id")
      category.save!
    end
  end
end
