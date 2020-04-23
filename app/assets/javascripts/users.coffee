# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#prealoading the avatar image.
$(document).ready ->
  $('#user_avatar').change (e) ->
    url = URL.createObjectURL(e.target.files[0])
    $('.img-edit-preview').attr("src",url)
    $('.img-edit-preview').onload = ->
      window.URL.revokeObjectURL($('.img-edit-preview').attr('src'))
      return
    return
  return
