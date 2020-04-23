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
    #summernote assignments.
    $('[data-provider="summernote"]').each ->
      $(this).summernote
        tabsize: 2
        height: 200
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
    $('a.search-toggle').on 'click', (e) ->
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
    return

  $(document).ready(ready)
  $(document).on('turbolinks:load', ready)

  #sticky cta
  $(document).scroll ->
    y = $(this).scrollTop()
    if y > 320
      $('html').addClass 'scrolled-past-hero'
    else
      $('html').removeClass 'scrolled-past-hero'

    if y > 440
      $('html').addClass 'toolbar-fixed'
    else
      $('html').removeClass 'toolbar-fixed'

    return
