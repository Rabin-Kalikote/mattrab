
json.array! @notifications do |notification|
  # json.recipient notification.recipient
  json.actor do
    json.name notification.actor.name
    json.avatar notification.actor.avatar
  end
  json.action notification.action
  json.read_at notification.read_at
  json.notifiable do
    json.type "a #{notification.notifiable_type.to_s.downcase}."
  end
  case notification.notifiable_type
    when 'Note'
      json.url note_path(notification.notifiable_id)
    when 'Comment'
      json.url note_path(Comment.find(notification.notifiable_id).note.id)
    when 'Follow'
      json.url user_path(notification.notifiable_id)
  end
  json.created_at "#{time_ago_in_words(notification.created_at)} ago"
end
