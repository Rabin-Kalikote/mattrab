module ApplicationHelper
  def default_meta_tags
    {
      title: 'Create, Share and Learn',
      site: 'Mattrab',
      reverse: true,
      separator: "&ndash;".html_safe,
      description: 'Mattrab is the interactive web application where +2 students create, share and learn from the notes, ask questions and answer them.',
      keywords: 'askmattrab mattrab online learning platform by students for students',
      og: { title: 'Create, Share and Learn', description: 'Mattrab is the interactive web application where +2 students create, share and learn from the notes, ask questions and answer them.', type: 'website', url: 'http://www.askmattrab.com', image: asset_path('mricon.png') },
      twitter: { card: 'mattrab', site: '@askmattrab', title: 'Create, Share and Learn', description: 'Mattrab is the interactive web application where +2 students create, share and learn from the notes, ask questions and answer them.',  image: asset_path('mricon.png') },
      refresh: 'Mattrab'
    }
  end
end
