# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  ready = ->
    # upvoting actions
    $('.q-upvote').click (e) ->
      e.preventDefault
      elem = $(this)
      q_id = elem.attr('id').split('@#!')[0]
      $.ajax
        url: '/questions/'+q_id+'/vote'
        type: 'put'
        data: {}
        success: (data) ->
          elem.html 'Helpful (' + data.count + ')'
          return
        error: (data) ->
      return
    $('.a-upvote').click (e) ->
      e.preventDefault
      elem = $(this)
      q_id = elem.attr('id').split('@#!')[0]
      a_id = elem.attr('id').split('@#!')[1]
      $.ajax
        url: '/questions/'+q_id+'/answers/'+a_id+'/vote'
        type: 'put'
        data: {}
        success: (data) ->
          elem.html 'Vote as Helpful Answer (' + data.count + ')'
          return
        error: (data) ->
      return

    # filtering the options of category in new/edit view.
    filterCategories = ->
      grade = $('#question_grade_id :selected').val()
      escaped_grade = grade.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
      category_options = $(categories).filter("optgroup[label='#{escaped_grade}']").html()
      if category_options
        $('#question_category_id').html(category_options)
        $('#question_category_id').parent().show()
      else
        $('#question_category_id').empty()
        $('#question_category_id').parent().hide()
      return
    filterChapters = ->
      category = $('#question_category_id :selected').val()
      escaped_category = category.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
      chapter_options = $(chapters).filter("optgroup[label='#{escaped_category}']").html()
      if chapter_options
        $('#question_chapter_id').html(chapter_options)
        $('#question_chapter_id').parent().show()
      else
        $('#question_chapter_id').empty()
        $('#question_chapter_id').parent().hide()
      return

    if $('#question_grade_id').length
      $('#question_category_id').parent().hide()
      $('#question_chapter_id').parent().hide()
      categories = $('#question_category_id').html()
      chapters = $('#question_chapter_id').html()
      filterCategories()
      filterChapters()
      $('#question_grade_id').change ->
        filterCategories()
        filterChapters()
      $('#question_category_id').change ->
        filterChapters()

    # select2 for chapters
    $('#question_chapter_id').select2
      allowClear: false, theme: 'classic'

    # infinite scrolling
    if $('.is .pagination').length
      $(window).scroll ->
        url = $(".pagination .page-link[rel=next]").attr("href")
        if url && $(window).scrollTop() > $(document).height()-$(window).height()-80
          $('.pagination-nav').html("<div class='spinner-grow' role='status'>
                                      <span class='sr-only'>Fetching more notes ...</span>
                                    </div>")
          $.getScript(url)
      $(window).scroll()
    return

  # $(document).ready(ready)
  $(document).on('turbolinks:load', ready)
