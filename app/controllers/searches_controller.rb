class SearchesController < ApplicationController
  def search
    @tab = params[:tab]
    @query = params[:query]

    case @tab
    when "notes"
      @results = Note.search(@query).published.paginate(page: params[:page], per_page: 7)
    when "questions"
      @results = Question.search(@query).paginate(page: params[:page], per_page: 7)
    when "users"
      @results = User.search(@query).paginate(page: params[:page], per_page: 7)
    else
      notes = Note.search(@query).published.to_a
      questions = Question.search(@query).to_a
      @results = notes.concat(questions).uniq.shuffle.paginate(page: params[:page], per_page: 7)
    end

    if @results.present? and @results.first.is_a? Note
      set_meta_tags title: @query, site: 'Mattrab Search', description: @results.first.body.gsub(/<[^>]*>/, '').truncate(150), keywords: @results.first.category.name+" class "+@results.first.grade.name,
                    og: { title: @query, description: @results.first.body.gsub(/<[^>]*>/, '').truncate(150), type: 'website', url: note_url(@results.first), image: @results.first.image },
                    twitter: { card: 'note', site: '@askmattrab', title: @query, description: @results.first.body.gsub(/<[^>]*>/, '').truncate(150), image: @results.first.image }
    elsif @results.present? and @results.first.is_a? Question
      set_meta_tags title: @query, site: 'Mattrab Search', description: @results.first.content.gsub(/<[^>]*>/, '').truncate(150), keywords: @results.first.category.name+" class "+@results.first.grade.name,
                    og: { title: @query, description: @results.first.content.gsub(/<[^>]*>/, '').truncate(150), type: 'website', url: question_url(@results.first) },
                    twitter: { card: 'note', site: '@askmattrab', title: @query, description: @results.first.content.gsub(/<[^>]*>/, '').truncate(150) }
    elsif @results.present? and @results.first.is_a? User
      set_meta_tags title: @query, site: 'Mattrab Search', description: @results.first.about, keywords: "Mattrab user at class "+@results.first.grade.name,
                    og: { title: @query, description: @results.first.about, type: 'website', url: user_url(@results.first), image: @results.first.avatar },
                    twitter: { card: 'note', site: '@askmattrab', title: @query, description: @results.first.about, image: @results.first.avatar }
    else
      set_meta_tags title: "No results found for #{@query}", site: 'Mattrab Search'
    end
  end
end
