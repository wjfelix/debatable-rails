// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .
//= require chosen-jquery
//= require jquery.tokeninput

/*
$(function() {
  var faye = new Faye.Client('http://localhost:9292/faye');
  faye.subscribe('/invitations/new', function(data) {
    alert(data);
  });
});
*/
// main function to process the fade request //
/*
 * jQuery Plugin: Tokenizing Autocomplete Text Entry
 * Version 1.6.0
 *
 * Copyright (c) 2009 James Smith (http://loopj.com)
 * Licensed jointly under the GPL and MIT licenses,
 * choose which one suits your project best!
 *
 */

$(function() {
  $("#user_tokens").tokenInput("/users.json", {
    propertyToSearch: 'fullname'
  });
});

this.InvitePoller = {
  poll: function() {
    return setTimeout(this.request, 5000);
  },
  request: function() {
    return $.get('/invites');
  }
};
jQuery(function() {
  if ($('#invitesContainer').length > 0) {
    return InvitePoller.poll();
  }
});
