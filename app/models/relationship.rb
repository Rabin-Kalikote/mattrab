class Relationship < ApplicationRecord

  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  validates :follower_id, presence: true
  validates :followed_id, presence: true

  # after_create :create_notifications
  #
  # def create_notifications
  #   Notification.create(recipient: self.followed_id.user, actor: self.follower_id.user, action: 'followed', notifiable: self)
  # end
end
