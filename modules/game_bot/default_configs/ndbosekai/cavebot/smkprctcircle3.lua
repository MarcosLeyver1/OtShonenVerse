local widget = setupUI([[
Panel
  size: 14 14
  height:385
  anchors.bottom: parent.bottom
  anchors.left: parent.left
  opacity: 1
  margin-left: 201

]], modules.game_interface.getMapPanel())

local highprcthp = g_ui.loadUIFromString([[
Label
  color: white
  background-color: #00000090
  opacity: 0.87
  anchors.bottom: parent.bottom
  margin-bottom: 205
  text-horizontal-auto-resize: true
  text-align: center
]], widget)

macro(200, function()
highprcthp:setText("25 ")
highprcthp:setColor("white")
end)