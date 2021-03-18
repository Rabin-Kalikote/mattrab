module ApplicationHelper
  def default_meta_tags
    {
      title: "Nepal's largest online learning platform",
      site: 'Mattrab',
      reverse: true,
      separator: "&ndash;".html_safe,
      description: "Mattrab is Nepal's largest online learning platform that offers free high-quality academic notes, answers questions, and builds student community engagement. Students from high school can ask their questions, browse through hundreds of resources and even follow their friends. Creator students can also create academic resources.",
      keywords: 'askmattrab, mattrab community, online learning platform, +2, 12, class 11, class 10, class 9, notes, questions, answers, physics, chemistry, biology, maths, computer, economics, account, english, nepali, science, health, high-quality academic contents',
      og: { title: "Nepal's largest online learning platform – Mattrab", description: "Mattrab is Nepal's largest online learning platform that offers free high-quality academic notes, answers questions, and builds student community engagement. Students from high school can ask their questions, browse through hundreds of resources and even follow their friends. Creator students can also create academic resources.", type: 'website', url: 'https://www.askmattrab.com', image: "https://www.askmattrab.com#{asset_path('askmattrab.png')}"},
      twitter: { card: 'summary', site: '@askmattrab', title: "Nepal's largest online learning platform – Mattrab", description: "Mattrab is Nepal's largest online learning platform that offers free high-quality academic notes, answers questions, and builds student community engagement. Students from high school can ask their questions, browse through hundreds of resources and even follow their friends. Creator students can also create academic resources.",  image: "https://www.askmattrab.com#{asset_path('askmattrab.png')}"},
      refresh: 'Mattrab'
    }
  end
end
