$ ->
  $('#new_team_logo').fileupload
    dataType: 'script'

    start: (e, data) ->
#      $('.fog').removeClass('hidden')

    add: (e, data) ->
      types = /(\.|\/)(gif|jpe?g|png)$/i
      file = data.files[0]

      if types.test(file.type) || types.test(file.name)
        data.submit()
      else
        alert("#{file.name} должен быть в формате gif, jpg или png")

    stop: (e, data) ->
      location.reload()

  $(".select-team-logo").ddslick
    width: '95px'
    onSelected: (data) ->
      $('.team_logo_id').val(data.selectedData.value)