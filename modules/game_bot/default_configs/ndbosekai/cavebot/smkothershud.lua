--Painel Others Hud
local othershud = setupUI([[
Panel
  size: 14 14
  height:500
  anchors.bottom: parent.bottom
  anchors.left: parent.left
  opacity: 1

  Label
    id: dash
    height: 12
    color: white
    font: verdana-11px-rounded
    background-color: #00000090
    anchors.bottom: parent.bottom
    margin-bottom: 405
    opacity: 0.87
    text-auto-resize: true
    text-align: center

  Label
    id: jump
    height: 12
    color: white
    font: verdana-11px-rounded
    background-color: #00000090
    anchors.bottom: parent.bottom
    margin-bottom: 390
    opacity: 0.87
    text-auto-resize: true
    text-align: center

]], modules.game_interface.getMapPanel())

macro(200, function()
if dash.isOn() then
othershud.dash:setText("~ Dash - Enabled")
othershud.dash:setColor("#33ff99")
else
othershud.dash:setText("~ Dash - Disabled")
othershud.dash:setColor("#ff6666")
end
if jump.isOn() then
othershud.jump:setText("~ Jump - Enabled")
othershud.jump:setColor("#33ff99")
else
othershud.jump:setText("~ Jump - Disabled")
othershud.jump:setColor("#ff6666")
end
end)