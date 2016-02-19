# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $('form').on 'click', '.remove_moderator_fields', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  $('form').on 'click', '.add_moderator_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()

  $('.debate_dropdown_style').change ->
    # change value of hidden size and update # of debater_invites forms
    debateStyle = $(this).val()
    newSize = $('.debate_size_style').val()

    # Q n A
    if debateStyle == '1'
      newSize = 2
    # 1 v 1
    else if debateStyle == '2'
      newSize = 2
    # 2 v 2
    else if debateStyle == '3'
      newSize = 4
    # 3 v 3
    else if debateStyle == '4'
      newSize = 6
    # 4 v 4
    else if debateStyle == '5'
      newSize = 8
    # Freetalk
    else if debateStyle == '8'
      newSize = 10
    $('.debate_size_style').val(newSize)

    # TODO: Change Number of debater_invites forms based on newSize
