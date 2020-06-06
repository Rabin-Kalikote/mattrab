# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  ready = ->
    #toggle search bar in mobile view.
    $('a.toggle-answer-modal').on 'click', (e) ->
      e.preventDefault()
      $('.submit-answer-modal').toggleClass 'd-none'
      return
    return

  # $(document).ready(ready)
  $(document).on('turbolinks:load', ready)
