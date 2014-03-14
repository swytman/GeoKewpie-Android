cards_toggle = (object) ->

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



$ ->
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

  $('#player-search').autocomplete({
    source: "/api/find_player?champ_id=#{champ_id}"
    select: (event, ui)->
      $('#player-info').html(ui.item.signed[0])
      $('.customtext').prop('value',ui.item.signed[1])
      $('.customtext').removeClass('disabled')
      $('#contract_player_id').val(ui.item.player_id)

  })

  $('.cards_pict').click (event)->
    cards_toggle(this)