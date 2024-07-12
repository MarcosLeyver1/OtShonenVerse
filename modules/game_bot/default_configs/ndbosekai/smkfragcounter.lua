--redskull counter
local widget = setupUI([[
Panel
  size: 14 14
  height:500
  anchors.bottom: parent.bottom
  anchors.left: parent.left
  opacity: 1
]], modules.game_interface.getMapPanel())

local getfrags = g_ui.loadUIFromString([[
Label
  color: white
  background-color: #00000090
  opacity: 0.87
  anchors.bottom: parent.bottom
  margin-bottom: 360
  text-horizontal-auto-resize: true
  text-align: center
]], widget)

local frags = ""

macro(100, function()
if frags then
getfrags:setText('~ Frags: '.. frags)
getfrags:setColor('#EBDAA2')
end
end)

onTextMessage(function(mode, text)
if string.find(text, "O assassinato de") then
say('!frags')
end
end)

onTextMessage(function (mode, text)
if string.find(text, "You do not have any unjustified kill.") then
frags = 0
end
end)

onTextMessage(function (mode, text)
if text:find('Voce tem ([0-9]+) frag') then
fragscounter = text:match("%d+")
frags = fragscounter
end
end)

local fragLimit = 15
macro(10, function()
    local isSafe = true;
    local specAmount = 0
    if not g_game.isAttacking() then
        return
    end
    for i,mob in ipairs(getSpectators()) do
        if (mob:isPlayer() and player:getName() ~= mob:getName()) then
            isSafe = false;
        end
    end
end)