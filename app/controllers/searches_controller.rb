class SearchesController < ApplicationController
  def search
    @tab = params[:tab]
    @query = params[:query]
    tags = @query.split.each_slice(1).map{|t|t.join ' '}

    case @tab
    when "notes"
      notes_from_search = Note.search(@query).to_a
      notes_from_tag = Note.tagged_with(tags, :any => true).to_a
      @results = notes_from_search.concat(notes_from_tag).paginate(page: params[:page], per_page: 7)
    when "questions"
      questions_from_search = Question.search(@query).to_a
      questions_from_tag = Question.tagged_with(tags, :any => true).to_a
      @results = questions_from_search.concat(questions_from_tag).paginate(page: params[:page], per_page: 7)
    else
      notes_from_search = Note.search(@query).to_a
      notes_from_tag = Note.tagged_with(tags, :any => true).to_a
      notes = notes_from_search.concat(notes_from_tag)

      questions_from_search = Question.search(@query).to_a
      questions_from_tag = Question.tagged_with(tags, :any => true).to_a
      questions = questions_from_search.concat(questions_from_tag)

      @results = notes.concat(questions).shuffle.paginate(page: params[:page], per_page: 7)
    end

    if @results.present? and @results.first.is_a? Note
      set_meta_tags title: @query, site: 'Mattrab Search', description: @results.first.body.gsub(/<[^>]*>/, '').truncate(150), keywords: @results.first.category.name+" class "+@results.first.grade.name,
                    og: { title: @query, description: @results.first.body.gsub(/<[^>]*>/, '').truncate(150), type: 'website', url: note_url(@results.first), image: @results.first.image },
                    twitter: { card: 'note', site: '@askmattrab', title: @query, description: @results.first.body.gsub(/<[^>]*>/, '').truncate(150), image: @results.first.image }
    elsif @results.present? and @results.first.is_a? Question
      set_meta_tags title: @query, site: 'Mattrab Search', description: @results.first.content.gsub(/<[^>]*>/, '').truncate(150), keywords: @results.first.category.name+" class "+@results.first.grade.name,
                    og: { title: @query, description: @results.first.content.gsub(/<[^>]*>/, '').truncate(150), type: 'website', url: question_url(@results.first) },
                    twitter: { card: 'note', site: '@askmattrab', title: @query, description: @results.first.content.gsub(/<[^>]*>/, '').truncate(150) }
    else
      set_meta_tags title: 'No results found', site: 'Mattrab Search'
    end
  end
end
