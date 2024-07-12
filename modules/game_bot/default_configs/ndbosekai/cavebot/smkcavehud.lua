--Painel Skills
local cavestatus = setupUI([[
Panel
  size: 14 14
  height:500
  anchors.bottom: parent.bottom
  anchors.left: parent.left
  opacity: 1

  Label
    id: atalhos
    height: 12
    color: white
    font: verdana-11px-rounded
    background-color: #00000090
    anchors.bottom: parent.bottom
    margin-bottom: 450
    opacity: 0.87
    text-auto-resize: true
    text-align: center

  Label
    id: cave
    height: 12
    color: white
    font: verdana-11px-rounded
    background-color: #00000090
    anchors.bottom: parent.bottom
    margin-bottom: 435
    opacity: 0.87
    text-auto-resize: true
    text-align: center

  Label
    id: target
    height: 12
    color: white
    font: verdana-11px-rounded
    background-color: #00000090
    anchors.bottom: parent.bottom
    margin-bottom: 420
    opacity: 0.87
    text-auto-resize: true
    text-align: center

]], modules.game_interface.getMapPanel())

macro(200, function()
cavestatus.atalhos:setText("[Atalhos: Ctrl+1 ao 5]")
cavestatus.atalhos:setColor("white")
if CaveBot.isOn() then
cavestatus.cave:setText("~ CaveBot - Enabled")
cavestatus.cave:setColor("#33ff99")
else
cavestatus.cave:setText("~ CaveBot - Disabled")
cavestatus.cave:setColor("#ff6666")
end
if TargetBot.isOn() then
cavestatus.target:setText("~ Target - Enabled")
cavestatus.target:setColor("#33ff99")
else
cavestatus.target:setText("~ Target - Disabled")
cavestatus.target:setColor("#ff6666")
end
end)