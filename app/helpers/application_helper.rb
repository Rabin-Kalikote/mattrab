module ApplicationHelper
  def default_meta_tags
    {
      title: 'Create, Share and Learn',
      site: 'Mattrab',
      reverse: true,
      separator: "&ndash;".html_safe,
      description: 'Mattrab is the interactive web application that enables the students around the country share and seek the learning helps/resources/notes from the friends and enable their academic success and journey to betterment.',
      keywords: 'askmattrab mattrab online learning platform by students for students',
      og: { title: 'Create, Share and Learn', description: 'Mattrab is the interactive web application that enables the students around the country share and seek the learning helps/resources/notes from the friends and enable their academic success and journey to betterment.', type: 'website', url: 'http://www.askmattrab.com' },
      twitter: { card: 'mattrab', site: '@askmattrab', title: 'Create, Share and Learn', description: 'Mattrab is the interactive web application that enables the students around the country share and seek the learning helps/resources/notes from the friends and enable their academic success and journey to betterment.' },
      refresh: 'Mattrab'
    }
  end
end
