# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#sticky cta
$(document).scroll ->
  y = $(this).scrollTop()
  if y > 320
    $('html').addClass 'scrolled-past-hero'
  else
    $('html').removeClass 'scrolled-past-hero'

  settingsOffset = $('#settings').offset().top
  if y+100 > settingsOffset
    $('#settings').addClass 'fixed'
  else
    $('#settings').removeClass 'fixed'

  return
