# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  sendFile = (that, file) ->
    data = new FormData
    data.append 'image[image]', file
    $.ajax
      data: data
      type: 'POST'
      url: "/images"
      cache: false
      contentType: false
      processData: false
      success: (data) ->
        img = document.createElement('IMG')
        img.src = data.url
        img.setAttribute('id', data.image_id)
        $(that).summernote 'insertNode', img

  deleteFile = (file_id) ->
    $.ajax
      type: 'DELETE'
      url: "/images/#{file_id}"
      cache: false
      contentType: false
      processData: false

  slideIndex = 1
  showSlides = (n) ->
    notes = $('.upvoted-note')
    slideIndex += n
    if slideIndex > notes.length
      slideIndex = 1
    if slideIndex < 1
      slideIndex = notes.length
    i = 0
    while i < notes.length
      notes[i].style.display = 'none'
      i++
    notes[slideIndex-1].style.display = 'block'
    return

  ready = ->
    #header assignments.
    $('.header-space').height($('header').height())
    #updating if the window has mobile-view.
    $(window).resize (e) ->
      if $(window).width() <= 767.98
        $('body').addClass('mobile').removeClass 'desktop'
      else
        $('body').addClass('desktop').removeClass 'mobile'
        $('.sm-nav-fixed-bottom').removeClass('scrolled-down')
      return
    $(window).resize()

    #summernote assignments.
    $('[data-provider="summernote"]').each ->
      $(this).summernote
        tabsize: 2
        height: 200
        placeholder: '....'
        toolbar: [['font', ['bold', 'underline','strikethrough', 'superscript', 'subscript', 'clear']],
                  ['font', ['style', 'color']],
                  ['para', ['ul', 'ol', 'paragraph', 'height']],
                  ['insert', ['link', 'picture', 'video', 'hr', 'table']],
                  ['view', ['fullscreen', 'help']]]
        callbacks:
          onImageUpload: (files) ->
            img = sendFile(this, files[0])
          onMediaDelete: (target, editor, editable) ->
            image_id = target[0].id
            if !!image_id
              deleteFile image_id
            target.remove()

    #toggle search bar in mobile view.
    $('a.search-toggle').unbind().on 'click', (e) ->
      e.preventDefault()
      $('.search-at-nav').toggleClass 'd-none'
      return

    #prealoading the note image.
    $('#note_image').change (e) ->
      url = URL.createObjectURL(e.target.files[0])
      $('.note-img-preview').attr("src",url)
      $('.note-img-preview').onload = ->
        window.URL.revokeObjectURL($('.note-img-preview').attr('src'))
        return
      return
    # handling question create.
    $('#inline_new_question').on 'submit', (e) ->
      e.preventDefault()
      $.ajax
        type: 'POST'
        url: $(this).attr('action')
        data: $(this).serialize()
        success: ->
          $('#question_content').val('');
          return
        error: ->
          alert 'Connection lost.'
          return
      return

    # upvote Notes
    $('.n-upvote').click (e) ->
      e.preventDefault
      n_id = $(this).attr('id').split('@#!')[0]
      $.ajax
        url: '/notes/'+n_id+'/thank'
        type: 'put'
        data: {}
        success: (data) ->
          $('.thanks-count').html data.count+' Thanks'
          return
        error: (data) ->
      return

    # print notes
    $('.print-note').click (e) ->
      e.preventDefault
      window.print()
      return

    # searching chapters in note index.
    $('.search-chapters').keyup ->
      filter = $('.search-chapters').val().toUpperCase()
      chapter = $('.chapters li')
      i = 0
      while i < chapter.length
        a = chapter[i].getElementsByTagName('a')[0]
        txtValue = a.textContent or a.innerText
        if txtValue.toUpperCase().indexOf(filter) > -1
          chapter[i].style.display = ''
        else
          chapter[i].style.display = 'none'
        i++
      return

    # toggling menu view in mobile view
    $('.chapters-menu input').focusin ->
      $('.chapters-menu').addClass 'focused'
      return
    $('.chapters-menu .chapters li a').click (e) ->
      $('.chapters-menu').removeClass 'focused'
      return
    $('.close-chapter-menu').click (e) ->
      e.preventDefault
      $('.chapters-menu').removeClass 'focused'
      return

    # filtering the options of category in new/edit view.
    filterCategories = ->
      grade = $('#note_grade_id :selected').val()
      escaped_grade = grade.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
      category_options = $(categories).filter("optgroup[label='#{escaped_grade}']").html()
      if category_options
        $('#note_category_id').html(category_options)
        $('#note_category_id').parent().show()
      else
        $('#note_category_id').empty()
        $('#note_category_id').parent().hide()
      return
    filterChapters = ->
      category = $('#note_category_id :selected').val()
      escaped_category = category.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
      chapter_options = $(chapters).filter("optgroup[label='#{escaped_category}']").html()
      if chapter_options
        $('#note_chapter_id').html(chapter_options)
        $('#note_chapter_id').parent().show()
      else
        $('#note_chapter_id').empty()
        $('#note_chapter_id').parent().hide()
      return

    if $('#note_grade_id').length
      $('#note_category_id').parent().hide()
      $('#note_chapter_id').parent().hide()
      categories = $('#note_category_id').html()
      chapters = $('#note_chapter_id').html()
      filterCategories()
      filterChapters()
      $('#note_grade_id').change ->
        filterCategories()
        filterChapters()
      $('#note_category_id').change ->
        filterChapters()

    # select2 for chapters
    $('#note_chapter_id').select2
      allowClear: false, theme: 'classic'

    # note navigations.
    if $('.grade-list').length
      $('.grade-item a.grade-link').click (e) ->
        e.preventDefault()
        id = $(this).attr("id")
        $(this).parent().addClass 'active'
        $(this).parent().siblings().removeClass 'active'
        $('.sticky-subnav-list.active').hide().removeClass 'active'
        $(".category-list##{id}").fadeIn(200).addClass 'active'

    # handling verification request
    $('.req_veri').click ->
      n_id = $('.req_veri').attr('id').split('@#!')[0]
      $.ajax
        url: "/notes/"+n_id+"/request_verification?admin="+$('#admin :selected').val()
        type: 'get'
        data: {}
        success: (data) ->
          $('.req_veri').html 'Requested'
          return
        error: (data) ->
          $('.req_veri').html 'Couldn\'t Request'
          return
      return
    $('#admin').change ->
      $('.req_veri').html 'Request Verification'
      return

    # handling the voded notes slides
    if $('.upvoted-note').length
      showSlides 1
      $('.prev-note').click (e) ->
        e.preventDefault
        showSlides -1
        return
      $('.next-note').click (e) ->
        e.preventDefault
        showSlides 1
        return

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

  # $(document).on('ready', ready)
  $(document).on('turbolinks:load', ready)

  $('html').find('iframe').not('.note-video-clip').not('.raLsWLhsVZ').remove()
