# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  $('[data-provider="summernote"]').each ->
    $(this).summernote
      # placeholder: 'An energy crisis is any significant bottleneck in the supply of energy resources to an economy. In literature, it often refers to one of the energy sources used at a ...',
      tabsize: 2,
      height: 200,
      toolbar: [['font', ['bold', 'underline','strikethrough', 'superscript', 'subscript', 'clear']],
                ['font', ['style', 'fontname', 'color']],
                ['para', ['ul', 'ol', 'paragraph', 'height']],
                ['insert', ['link', 'picture', 'video', 'hr', 'table']],
                ['view', ['fullscreen', 'help']]]
      #airMode: true,
      #focus: true

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
