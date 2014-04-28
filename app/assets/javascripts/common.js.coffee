window.cards_toggle = (object, val = null) ->
  if val == null
    val = $(object).attr('card')
    val =
    switch val
      when "no"
        "yellow"
      when "yellow"
        "dbl_yellow"
      when "dbl_yellow"
        "red"
      when "red"
        "no"
  $(object).attr('card', val)
  $(object).attr('src', $(object).attr(val))

resizeInput = () ->

  $(this).width($(this).val().length*23)



$ ->
  $('table.sortable').tablesorter();

  $('input[type="text"].score_field')
    .keyup(resizeInput)
    .each(resizeInput)

  $('input').keyup ->
    value = $(this).val()
    $(this).attr('value', value)

  if champ_id == undefined
    champ_id = null
  # enable chosen js
  $('.chosen-select').chosen
    allow_single_deselect: true
    no_results_text: 'Нет найдено'
    width: '100%'

  $('.datepicker').datepicker
    numberOfMonths: 3,
    showButtonPanel: true

  $('.datemask').mask("99/99/9999")
  $(".mask-number").mask("9?9", {placeholder:""});

#  $('#player-search').autocomplete({
#    source: "/api/find_player?champ_id=#{window.champ_id}"
#    select: (event, ui)->
#      $('#player-info').html(ui.item.signed[0])
#      $('.customtext').prop('value',ui.item.signed[1])
#      $('.customtext').removeClass('disabled')
#      $('#contract_player_id').val(ui.item.player_id)
#
#  })

  $('.cards_pict').click (event)->
    target = $(this).attr('player-id')
    card = this
    $("input[type='checkbox'][player-id="+target+"]").each ->
      if $(this).prop('checked') == true
        cards_toggle(card)
  $('.nav.nav-tabs a').click (e) ->
    e.preventDefault()
    $(this).tab('show')
