
json.array! @notifications do |notification|
  # json.recipient notification.recipient
  json.actor do
    json.name notification.actor.name
    json.avatar notification.actor.avatar
  end
  json.action notification.action
  json.read_at notification.read_at

  case notification.notifiable_type
    when 'Note'
      json.type "a #{notification.notifiable_type}."
      if notification.action == 'asked for Verification of'
        json.url edit_note_path(notification.notifiable_id)
      else
        json.url note_path(notification.notifiable_id)
      end
    when 'Question'
      json.url question_path(notification.notifiable_id)
      if notification.action == 'answered'
        # json.url note_path(Question.find(notification.notifiable_id).note.id)
        json.type "in your #{notification.notifiable_type}."
      else
        json.type "a #{notification.notifiable_type}."
      end
    when 'Relationship'
      json.type "you."
      json.url user_path(notification.notifiable.follower_id)
  end
  json.created_at "#{time_ago_in_words(notification.created_at)} ago"
end
