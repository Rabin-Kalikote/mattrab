class Comment < ApplicationRecord
  belongs_to :note
  belongs_to :user

  after_create :create_notifications

  def create_notifications
    Notification.create(recipient: self.note.user, actor: self.user, action: 'commented', notifiable: self.note)
  end
end
