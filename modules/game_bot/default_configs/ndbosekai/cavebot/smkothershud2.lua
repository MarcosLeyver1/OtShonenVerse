--Painel OthersHud2
local othershud2 = setupUI([[
Panel
  size: 14 14
  height:500
  anchors.bottom: parent.bottom
  anchors.left: parent.left
  opacity: 1

  Label
    id: manatrain
    height: 12
    color: white
    font: verdana-11px-rounded
    background-color: #00000090
    anchors.bottom: parent.bottom
    margin-bottom: 375
    opacity: 0.87
    text-auto-resize: true
    text-align: center

]], modules.game_interface.getMapPanel())

macro(200, function()
if manatrain.isOn() then
othershud2.manatrain:setText("~ Mana Down - Enabled")
othershud2.manatrain:setColor("#33ff99")
else
othershud2.manatrain:setText("~ Mana Down - Disabled")
othershud2.manatrain:setColor("#ff6666")
end
end)