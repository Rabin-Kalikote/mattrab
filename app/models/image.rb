class Image < ApplicationRecord
  has_attached_file :image, default_url: "/images/small/missing.png"
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
end
