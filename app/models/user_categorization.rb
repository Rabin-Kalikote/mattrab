class UserCategorization < ApplicationRecord
  belongs_to :category
  belongs_to :user
end
