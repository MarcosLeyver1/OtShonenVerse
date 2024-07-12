setDefaultTab("Tools")
UI.Separator()
UI.Label("-- Utilities --"):setColor('#EBDAA2') 
--Mana Train
manatrain = macro(1000, "Mana Train", ("CTRL+5"), function()
 if (manapercent() == 100) and storage.automanatrain:len() > 1 then
 say(storage.automanatrain)
 delay(100)
 else
 say('')
 delay(2000)
end
end)
UI.TextEdit(storage.automanatrain or "", function(widget, text)    
  storage.automanatrain = text
end)

--create food
macro(100, "Create Food", function()
 if soul() >= 10 and storage.createfood:len() > 1 then
 say(storage.createfood)
 end
 end)
 UI.TextEdit(storage.createfood or "", function(widget, text)    
  storage.createfood = text
end)
UI.Separator()

UI.Label("-- Extra --"):setColor('#EBDAA2')
--automsgtrade
macro(100, "Auto Trade Msg", function()
  local trade = getChannelId("Vendas")
  if not trade then
    trade = getChannelId("Vendas")
  end
  if trade and storage.autotrademsg:len() > 0 then    
    sayChannel(trade, storage.autotrademsg)
	delay(60000)
  end
end)
UI.TextEdit(storage.autotrademsg or "sell/buy alguma coisa", function(widget, text)    
  storage.autotrademsg = text
end)

--autofollow
local followThis = tostring(storage.followLeader1)

FloorChangers = {
    Ladders = {
        Up = {1948},
        Down = {}
    },

    Holes = {
        Up = {},
        Down = {}
    },

    RopeSpots = {
        Up = {386},
        Down = {}
    },

    Stairs = {
        Up = {16690, 1958, 7548, 7544, 1952, 1950, 1947, 7542, 855, 856, 1978, 1977, 6911, 6915, 1954, 5259, 20492, 1956, 1957, 1955, 5257, 22192, 22194, 11479, 5258, 10235, 1082, 1954, 605, 6130, 1083, 11477, 11483, 16297, 11478, 11476, 13395, 1954, 1952, 469, 1128, 1112},
        Down = {482, 414, 413, 437, 7731, 412, 434, 859, 438, 6127, 566, 7476, 4826, 4825, 16299, 16300, 16302}
    },

    Sewers = {
        Up = {},
        Down = {}
    },
}

local target = followThis
local lastKnownPosition

local function goLastKnown()
    if getDistanceBetween(pos(), {x = lastKnownPosition.x, y = lastKnownPosition.y, z = lastKnownPosition.z}) > 1 then
        local newTile = g_map.getTile({x = lastKnownPosition.x, y = lastKnownPosition.y, z = lastKnownPosition.z})
        if newTile then
            g_game.use(newTile:getTopUseThing())
            delay(100)
        end
    end
end

local function handleUse(pos)
    goLastKnown()
    local lastZ = posz()
    if posz() == lastZ then
        local newTile = g_map.getTile({x = pos.x, y = pos.y, z = pos.z})
        if newTile then
		    g_game.use(newTile:getTopUseThing())
            delay(100)
        end
    end
end

local function handleStep(pos)
    goLastKnown()
    local lastZ = posz()
    if posz() == lastZ then
        autoWalk(pos)
        delay(100)
    end
end

local function handleRope(pos)
    goLastKnown()
    local lastZ = posz()
    if posz() == lastZ then
        local newTile = g_map.getTile({x = pos.x, y = pos.y, z = pos.z})
        if newTile then
            say('skip')
            delay(100)
        end
    end
end


local floorChangeSelector = {
    Ladders = {Up = handleUse, Down = handleStep},
    Holes = {Up = handleStep, Down = handleStep},
    RopeSpots = {Up = handleRope, Down = handleRope},
    Stairs = {Up = handleStep, Down = handleStep},
    Sewers = {Up = handleUse, Down = handleUse},
}

local function distance(pos1, pos2)
    local pos2 = pos2 or lastKnownPosition or pos()
    return math.abs(pos1.x - pos2.x) + math.abs(pos1.y - pos2.y)
end

local function checkTargetPos()
    local c = getCreatureByName(target)
    if c and c:getPosition().z == posz() then
        lastKnownPosition = c:getPosition()
    end
end

local function executeClosest(possibilities)
    local closest
    local closestDistance = 3
    for _, data in ipairs(possibilities) do
        local dist = distance(data.pos)
        if dist < closestDistance then
            closest = data
            closestDistance = dist
        end
    end

    if closest then
        closest.changer(closest.pos)
    end
end

local function handleFloorChange()
    local c = getCreatureByName(target)
    local range = 3
    local p = pos()
    local possibleChangers = {}
    for _, dir in ipairs({"Down", "Up"}) do
        for changer, data in pairs(FloorChangers) do
            for x = -range, range do
                for y = -range, range do
                    local tile = g_map.getTile({x = p.x + x, y = p.y + y, z = p.z})
                    if tile then
                        if table.find(data[dir], tile:getTopUseThing():getId()) then
                            table.insert(possibleChangers, {changer = floorChangeSelector[changer][dir], pos = {x = p.x + x, y = p.y + y, z = p.z}})
                        end
                    end
                end
            end
        end
    end
    executeClosest(possibleChangers)
end

local function targetMissing()
    for _, n in ipairs(getSpectators(false)) do
        if n:getName() == target then
            return n:getPosition().z ~= posz()
        end
    end
    return true
end

macro(100, "Follow", function(macro)
    local c = getCreatureByName(target)

    if g_game.isFollowing() then
        if g_game.getFollowingCreature() ~= c then
            g_game.cancelFollow()
            g_game.follow(c)
        end
    end

    if c and not g_game.isFollowing() then
        g_game.follow(c)
    elseif c and g_game.isFollowing() and getDistanceBetween(pos(), c:getPosition()) > 1 then
        g_game.cancelFollow()
        g_game.follow(c)
    end

    checkTargetPos()
    if targetMissing() and lastKnownPosition then
        handleFloorChange()
    end
end)

addTextEdit("playerToFollow", storage.followLeader1 or "nome do player", function(widget, text)
    storage.followLeader1 = text
    target = tostring(text)
end)

--auto trocar dinheiro
macro(500, "Trocar Dinheiro", function()
  for i, container in pairs(getContainers()) do
    for j, item in ipairs(container:getItems()) do
      if item:getId(storage.autochangegold) and item:getCount() == 100 then
        g_game.use(item)
        return
      end
    end
  end
end)
UI.TextEdit(storage.autochangegold or "3035", function(widget, text)    
  storage.autochangegold = text
end)
UI.Separator()

UI.Label("-- Guild Only --"):setColor('#EBDAA2') 
--auto invite pt from guild
autoptinvite = macro(100, "Auto Party Invite", function()
for i,v in ipairs (getSpectators(posz())) do
	if v ~= player and v:isPlayer() and v:getShield() == 0 and v:getEmblem() == 1 then
		g_game.partyInvite(v:getId())
	end
end
end)
addIcon("autoptinvite", {item=797, text="PT Recr",}, function(icon, isOn)
  autoptinvite.setOn(isOn) 
end)

--auto accept pt from guild
autoptjoin = macro(100, "Auto Party Join", function()
for i,v in ipairs (getSpectators(posz())) do
	if v ~= player and v:isPlayer() and v:getShield() == 1 and v:getEmblem() == 1 then
		g_game.partyJoin(v:getId())
	end
end
end)
addIcon("autoptjoin", {item=15394, text="PT Join",}, function(icon, isOn)
  autoptjoin.setOn(isOn) 
end)
UI.Separator()