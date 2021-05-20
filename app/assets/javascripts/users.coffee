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

    # handling change role request.
    $('.change-role').click ->
      u_id = $('.change-role').attr('id').split('@#!')[0]
      $.ajax
        url: "/users/"+u_id+"/change_role?role="+$('#role :selected').val()
        type: 'get'
        data: {}
        success: (data) ->
          $('.change-role').html 'Changed'
          return
        error: (data) ->
          $('.change-role').html 'Couldn\'t Change'
          return
      return
    $('#role').change ->
      $('.change-role').html 'Change Role'
      return

    # filtering the options of category in edit view.
    filterOptions = ->
      grade = $('#user_grade_id :selected').val()
      escaped_grade = grade.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
      category_options = $(categories).filter("optgroup[label='#{escaped_grade}']").html()
      if category_options
        $('#user_category_id').html(category_options)
        $('#user_category_id').parent().show()
      else
        $('#user_category_id').empty()
        $('#user_category_id').parent().hide()
      return

    if $('#user_grade_id').length
      $('#user_category_id').parent().hide()
      categories = $('#user_category_id').html()
      filterOptions()
      $('#user_grade_id').change ->
        filterOptions()
    return

  # $(document).ready(ready)
  $(document).on('turbolinks:load', ready)
