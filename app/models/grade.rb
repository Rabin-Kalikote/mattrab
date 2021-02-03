class Grade < ApplicationRecord
  validates :name, presence: true
  enum name: [:twelve, :eleven, :ten, :nine, :eight, :seven]
  has_many :users
  has_many :categories
  has_many :notes
  has_many :questions
end
