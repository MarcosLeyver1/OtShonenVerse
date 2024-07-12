--Painel Skills
local skills = setupUI([[
Panel
  size: 14 14
  height:500
  anchors.bottom: parent.bottom
  anchors.left: parent.left
  opacity: 1




  Label
    id: skills1
    height: 12
    color: #FFE4C4
    font: verdana-11px-rounded
    background-color: #00000090
    anchors.bottom: parent.bottom
    margin-bottom: 120
    opacity: 0.87
    text-auto-resize: true
    text-align: center


  Label
    id: skills3
    height: 12
    color: 	#6495ED
    font: verdana-11px-rounded
    background-color: #00000090
    anchors.bottom: parent.bottom
    margin-bottom: 105
    opacity: 0.87
    text-auto-resize: true
    text-align: center



  Label
    id: skills5
    height: 12
    color: #90EE90
    font: verdana-11px-rounded
    background-color: #00000090
    anchors.bottom: parent.bottom
    margin-bottom: 90
    opacity: 0.87
    text-auto-resize: true
    text-align: center

  Label
    id: skills9
    height: 12
    color: #DB7093
    font: verdana-11px-rounded
    background-color: #00000090
    anchors.bottom: parent.bottom
    margin-bottom: 75
    opacity: 0.87
    text-auto-resize: true
    text-align: center

  Label
    id: skills11
    height: 12
    color: #F4A460
    font: verdana-11px-rounded
    background-color: #00000090
    anchors.bottom: parent.bottom
    margin-bottom: 60
    opacity: 0.87
    text-auto-resize: true
    text-align: center

  Label
    id: skills15
    height: 12
    color: #E6E6FA
    font: verdana-11px-rounded
    background-color: #00000090
    anchors.bottom: parent.bottom
    margin-bottom: 45
    opacity: 0.87
    text-auto-resize: true
    text-align: center




]], modules.game_interface.getMapPanel())

local doFormatTime = function(v)
    local horas = string.format("%02.f", math.floor(v / 60))
    local segundos = string.format("%02.f", math.floor(math.mod(v, 60)))
    return horas .. ":" .. segundos
end


macro(200, function()
skills.skills1:setText("~ Level: ".. player:getLevel() .. " - (".. player:getLevelPercent() .."%)")
skills.skills3:setText("~ Magic: ".. player:getMagicLevel().. " - (".. player:getMagicLevelPercent() .."%)")
skills.skills5:setText("~ Atk Spd: ".. player:getSkillLevel() .. " - (".. player:getSkillLevelPercent() .."%)")
skills.skills9:setText("~ Sword: ".. player:getSkillLevel(2) .. " - (".. player:getSkillLevelPercent(2) .."%)")
skills.skills11:setText("~ Distance: ".. player:getSkillLevel(4) .. " - (".. player:getSkillLevelPercent(4) .."%)")
skills.skills15:setText("~ Stamina:".. "  ".. doFormatTime(player:getStamina()))
end)

if not storage.timers then  storage.timers = {  time = 1 } end
local widgetTC = setupUI([[
Panel
  size: 14 14
  anchors.bottom: parent.bottom
  anchors.left: parent.left
  margin-bottom: 125
  Label
    id: lblTimer
    color: #FF1493
    font: verdana-11px-rounded
    height: 12
    background-color: #00000040
    opacity: 0.87
    background-color: #00000090
    text-auto-resize: true
]], modules.game_interface.getMapPanel())
