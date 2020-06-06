# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  ready = ->
    #prealoading the avatar image.
    $('#user_avatar').change (e) ->
      url = URL.createObjectURL(e.target.files[0])
      $('.img-edit-preview').attr("src",url)
      $('.img-edit-preview').onload = ->
        window.URL.revokeObjectURL($('.img-edit-preview').attr('src'))
        return
      return

    # filtering the options of category in edit view.
    filterOptions = ->
      $('.grade-category-list').hide()
      grade = $('#user_grade_id :selected').text()
      escaped_grade = grade.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
      $(".grade-category-list##{escaped_grade}").show()

    if $('#user_grade_id').length
      filterOptions()
      $('#user_grade_id').change ->
        filterOptions()
    return

  # $(document).ready(ready)
  $(document).on('turbolinks:load', ready)
