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

    if @results.present?
      set_meta_tags title: @query, site: 'Mattrab Search', description: "Search form hundreds of notes, questions, and answers. Find notes for every subject of class 12, 11, 10, and 9. Also, find the users of askmattrab", keywords: "#{@query}, Mattrab Search, Search notes, Search questions, Search answers, Search askmattrab",
                    og: { title: @query, description: "Search form hundreds of notes, questions, and answers. Find notes for every subject of class 12, 11, 10, and 9. Also, find the users of askmattrab", type: 'website' },
                    twitter: { title: @query, description: "Search form hundreds of notes, questions, and answers. Find notes for every subject of class 12, 11, 10, and 9. Also, find the users of askmattrab"}
    else
      set_meta_tags title: "No results found for #{@query}", site: 'Mattrab Search'
    end
  end
end
