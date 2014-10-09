# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$ ->
  $('#champ_label_css_schema').change ->
    $('.short-table#label-example').removeClass('gold red green platinum bronze')
    $('.short-table#label-example').addClass($(this).val())