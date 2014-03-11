$ ->
  # enable chosen js
  $('.chosen-select').chosen
    allow_single_deselect: true
    no_results_text: 'Нет найдено'
    width: '100%'

  $('.datepicker').datepicker
    numberOfMonths: 3,
    showButtonPanel: true