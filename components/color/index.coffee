green = '00e5bf'
blue = '235AFF'
ratio = 0.5
min = -10
max = 10
new_min = 0
new_max = 1

module.exports =
  lightOrDark: (hex)->
    if (parseInt(hex, 16) > 0xffffff/2) then 'light' else 'dark'

  bound: bound = (_number) ->
    Math.max(Math.min(_number, max), min)

  convert: convert = (value) ->
    ( (value - min) / (max - min) ) * (new_max - new_min) + new_min

  ratio: ratio = (percentage) ->
    convert bound(percentage)

  toHex: toHex = (x) ->
    x = x.toString(16)
    hex = if (x.length == 1) then '0' + x else x

  getColor: getColor = (percentage) ->
    _ratio = ratio percentage

    r = Math.ceil(parseInt(green.substring(0,2), 16) * _ratio + parseInt(blue.substring(0,2), 16) * (1 - _ratio))
    g = Math.ceil(parseInt(green.substring(2,4), 16) * _ratio + parseInt(blue.substring(2,4), 16) * (1 - _ratio))
    b = Math.ceil(parseInt(green.substring(4,6), 16) * _ratio + parseInt(blue.substring(4,6), 16) * (1 - _ratio))

    middle = toHex(r) + toHex(g) + toHex(b)
