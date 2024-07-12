local widget = setupUI([[
Panel
  size: 14 14
  height:500
  anchors.bottom: parent.bottom
  anchors.left: parent.left
  opacity: 1
  margin-left: 200

]], modules.game_interface.getMapPanel())

local highprcthp = g_ui.loadUIFromString([[
Label
  color: white
  background-color: #00000090
  opacity: 0.87
  anchors.bottom: parent.bottom
  anchors.left: parent.left
  margin-bottom: 320
  text-horizontal-auto-resize: true
  text-align: center 
]], widget)

macro(200, function()
highprcthp:setText("75 ")
highprcthp:setColor("white")
end)