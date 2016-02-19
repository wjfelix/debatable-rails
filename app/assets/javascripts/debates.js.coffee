# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

function colorFade(id,element,start,end,steps,speed) {
  var startrgb,endrgb,er,eg,eb,step,rint,gint,bint,step;
  var target = document.getElementById(id);
  steps = steps || 20;
  speed = speed || 20;
  clearInterval(target.timer);
  endrgb = colorConv(end);
  er = endrgb[0];
  eg = endrgb[1];
  eb = endrgb[2];
  if(!target.r) {
    startrgb = colorConv(start);
    r = startrgb[0];
    g = startrgb[1];
    b = startrgb[2];
    target.r = r;
    target.g = g;
    target.b = b;
  }
  rint = Math.round(Math.abs(target.r-er)/steps);
  gint = Math.round(Math.abs(target.g-eg)/steps);
  bint = Math.round(Math.abs(target.b-eb)/steps);
  if(rint == 0) { rint = 1 }
  if(gint == 0) { gint = 1 }
  if(bint == 0) { bint = 1 }
  target.step = 1;
  target.timer = setInterval( function() { animateColor(id,element,steps,er,eg,eb,rint,gint,bint) }, speed);
}

// incrementally close the gap between the two colors //
function animateColor(id,element,steps,er,eg,eb,rint,gint,bint) {
  var target = document.getElementById(id);
  var color;
  if(target.step <= steps) {
    var r = target.r;
    var g = target.g;
    var b = target.b;
    if(r >= er) {
      r = r - rint;
    } else {
      r = parseInt(r) + parseInt(rint);
    }
    if(g >= eg) {
      g = g - gint;
    } else {
      g = parseInt(g) + parseInt(gint);
    }
    if(b >= eb) {
      b = b - bint;
    } else {
      b = parseInt(b) + parseInt(bint);
    }
    color = 'rgb(' + r + ',' + g + ',' + b + ')';
    if(element == 'background') {
      target.style.backgroundColor = color;
    } else if(element == 'border') {
      target.style.borderColor = color;
    } else {
      target.style.color = color;
    }
    target.r = r;
    target.g = g;
    target.b = b;
    target.step = target.step + 1;
  } else {
    clearInterval(target.timer);
    color = 'rgb(' + er + ',' + eg + ',' + eb + ')';
    if(element == 'background') {
      target.style.backgroundColor = color;
    } else if(element == 'border') {
      target.style.borderColor = color;
    } else {
      target.style.color = color;
    }
  }
}

// convert the color to rgb from hex //
function colorConv(color) {
  var rgb = [parseInt(color.substring(0,2),16),
    parseInt(color.substring(2,4),16),
    parseInt(color.substring(4,6),16)];
  return rgb;
}

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
