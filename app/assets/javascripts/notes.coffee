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

    #bottom-nav scroll-behavior.
    if $('.mobile').length
      last_scroll_top = 0
      $(window).on 'scroll', ->
        scroll_top = $(this).scrollTop()
        if scroll_top < last_scroll_top
          $('.mobile .sm-nav-fixed-bottom').removeClass('scrolled-down').addClass 'scrolled-up'
        else
          $('.mobile .sm-nav-fixed-bottom').removeClass('scrolled-up').addClass 'scrolled-down'
        last_scroll_top = scroll_top
        return

    # sticky home sidebar indesktop
    ((a, b) ->
      a.extend stickysidebarscroll: (c, e) ->
        `var c`
        if e and e.offset
          e.offset.bottom = parseInt(e.offset.bottom, 10)
          e.offset.top = parseInt(e.offset.top, 10)
        else
          e.offset =
            bottom: 100
            top: 0
        c = a(c)
        if c and c.offset()
          j = c.offset().top
          q = c.offset().left
          o = c.outerHeight(true)
          k = c.outerWidth()
          h = c.css('position')
          g = c.css('top')
          f = parseInt(c.css('marginTop'), 10)
          n = a(document).height()
          l = a(document).height() - (e.offset.bottom)
          m = 0
          d = false
          i = false
          p = false
          if e.forcemargin == true or navigator.userAgent.match(/\bMSIE (4|5|6)\./) or navigator.userAgent.match(/\bOS (3|4|5|6)_/) or navigator.userAgent.match(/\bAndroid (1|2|3|4)\./i)
            p = true
          a(window).bind 'scroll resize orientationchange load', c, (t) ->
            if n != a(document).height()
              l = a(document).height() - (e.offset.bottom)
              n = a(document).height()
            if i == false
              j = c.offset().top
            s = c.outerHeight()
            r = a(window).scrollTop()
            if p and document.activeElement and document.activeElement.nodeName == 'INPUT'
              return
            i = true
            if r >= j - (if f then f else 0) - (e.offset.top)
              if l < r + s + f + e.offset.top
                m = r + s + f + e.offset.top - l
              else
                m = 0
              if p
                c.css marginTop: parseInt((if f then f else 0) + r - j - m + 2 * e.offset.top, 10) + 'px'
              else
                c.css
                  position: 'fixed'
                  top: e.offset.top - m + 'px'
                  width: k + 'px'
            else
              i = false
              q = c.offset().left
              c.css
                position: h
                top: g
                left: q
                width: k + 'px'
                marginTop: (if f then f else 0) + 'px'
            return
        return
      return
    ) jQuery

    $.stickysidebarscroll '.desktop .sticky-in-desktop', offset:
      top: 90
      bottom: 200

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

    #handle nav-search-icon click.
    $('a.ask').on 'click', (e) ->
      e.preventDefault()
      if $('input.search_input').length
        $('input.search_input').focus()
      else
        $('.search-modal').toggleClass 'd-none'
      return

    #scrolling the home grade-class nav.

    # duration of scroll animation
    scrollDuration = 300
    # paddles
    leftPaddle = document.getElementsByClassName('left-paddle')
    rightPaddle = document.getElementsByClassName('right-paddle')
    # get items dimensions
    itemsLength = $('.item').length
    itemSize = $('.item').outerWidth(true)
    # get some relevant size for the paddle triggering point
    paddleMargin = 50
    # get wrapper width

    getMenuWrapperSize = ->
      $('.menu-wrapper').outerWidth()

    menuWrapperSize = getMenuWrapperSize()
    # the wrapper is responsive
    $(window).on 'resize', ->
      menuWrapperSize = getMenuWrapperSize()
      return
    # size of the visible part of the menu is equal as the wrapper size
    menuVisibleSize = menuWrapperSize
    # get total width of all menu items

    getMenuSize = ->
      itemsLength * itemSize

    menuSize = getMenuSize()
    # get how much of menu is invisible
    menuInvisibleSize = menuSize - menuWrapperSize
    # get how much have we scrolled to the left

    getMenuPosition = ->
      $('.menu').scrollLeft()

    # finally, what happens when we are actually scrolling the menu
    $('.menu').on 'scroll', ->
      # get how much of menu is invisible
      menuInvisibleSize = menuSize - menuWrapperSize
      # get how much have we scrolled so far
      menuPosition = getMenuPosition()
      menuEndOffset = menuInvisibleSize - paddleMargin
      # show & hide the paddles
      # depending on scroll position
      if menuPosition <= paddleMargin
        $(leftPaddle).addClass 'hidden'
        $(rightPaddle).removeClass 'hidden'
      else if menuPosition < menuEndOffset
        # show both paddles in the middle
        $(leftPaddle).removeClass 'hidden'
        $(rightPaddle).removeClass 'hidden'
      else if menuPosition >= menuEndOffset
        $(leftPaddle).removeClass 'hidden'
        $(rightPaddle).addClass 'hidden'
      return
    # scroll to left
    $(rightPaddle).click ->
      $('.menu').animate { scrollLeft: '+=' + menuVisibleSize }, scrollDuration
      return
    # scroll to right
    $(leftPaddle).click ->
      $('.menu').animate { scrollLeft: '-=' + menuVisibleSize }, scrollDuration
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

    # filtering the options of category in new/edit view.
    filterOptions = ->
      grade = $('#note_grade_id :selected').text()
      escaped_grade = grade.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
      options = $(categories).filter("optgroup[label='#{escaped_grade}']").html()
      if options
        $('#note_category_id').html(options)
        $('#note_category_id').parent().show()
      else
        $('#note_category_id').empty()
        $('#note_category_id').parent().hide()

    if $('#note_grade_id').length
      $('#note_category_id').parent().hide()
      categories = $('#note_category_id').html()
      filterOptions()
      $('#note_grade_id').change ->
        filterOptions()

    # note navigations.
    if $('.grade-list').length
      $('.grade-item a.grade-link').click (e) ->
        e.preventDefault()
        id = $(this).attr("id")
        $(this).hide()
        $(this).parent().siblings().hide()
        $(".category-list##{id}").fadeIn()

      $('.back-item a.back-link').click (e) ->
        e.preventDefault()
        $(".grade-list .grade-item").fadeIn()
        $('.category-list').hide()
        $(".grade-item a.grade-link").fadeIn()

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
  $(document).on('ready', ready)

  $('html').find('iframe').not('.note-video-clip').not('.raLsWLhsVZ').remove()

  #sticky cta
  if $('.sticky-subnav').length
    $(document).scroll ->
      y = $(this).scrollTop()
      if y > 320
        $('html').addClass 'scrolled-past-hero'
      else
        $('html').removeClass 'scrolled-past-hero'
      return
