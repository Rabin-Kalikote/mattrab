# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://www.askmattrab.com"

# Where you want your sitemap.xml.gz file to be uploaded.
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(
  aws_access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
  aws_secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
  fog_provider: 'AWS',
  fog_directory: ENV.fetch('S3_BUCKET_NAME'),
  fog_region: ENV.fetch('AWS_REGION')
)
SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
# The full path to your bucket
SitemapGenerator::Sitemap.sitemaps_host = "https://#{ENV.fetch('S3_BUCKET_NAME')}.s3.amazonaws.com"
SitemapGenerator::Sitemap.ping_search_engines('https://askmattrab.com/sitemap')

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end

  # Add '/home'
  add '/home', :changefreq => 'daily', :priority => 0.9

  # Add '/notes'
  add notes_path, :priority => 0.7, :changefreq => 'daily'
  # Add all notes:
  Note.find_each do |note|
    add note_path(note), :lastmod => note.updated_at
  end

  # Add '/questions'
  add questions_path, :priority => 0.7, :changefreq => 'daily'
  # Add all questions:
  Question.find_each do |question|
    add question_path(question), :lastmod => question.updated_at
  end

  # Add '/users'
  add users_path, :priority => 0.7, :changefreq => 'daily'
  # Add all users:
  User.find_each do |user|
    add user_path(user), :lastmod => user.updated_at
  end

  # Add '/others'
  add '/search', :changefreq => 'daily', :priority => 0.7
  add '/about'
  add '/faqs'
  add '/affiliate_program'
  add '/terms'
  add '/privacy'
  add '/creator_appeal'
  add '/users/sign_up'
  add '/users/sign_in'
end
