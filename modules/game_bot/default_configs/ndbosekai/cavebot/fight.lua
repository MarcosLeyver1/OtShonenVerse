setDefaultTab("Fight")
UI.Separator()
UI.Label("-- Mobility --"):setColor('#EBDAA2')
--BugMap AWSD/Setas/NumPad
local function checkPos(x, y)
 xyz = g_game.getLocalPlayer():getPosition()
 xyz.x = xyz.x + x
 xyz.y = xyz.y + y
 tile = g_map.getTile(xyz)
 if tile then
  return g_game.use(tile:getTopUseThing())  
 else
  return false
 end
end

dash = macro(100, "Dash", ('CTRL+3'), function()
 if modules.corelib.g_keyboard.isKeyPressed('w') or modules.corelib.g_keyboard.isKeyPressed('Up') or modules.corelib.g_keyboard.isKeyPressed('numpad8') then
  checkPos(0, -3)
 elseif modules.corelib.g_keyboard.isKeyPressed('e') then
  checkPos(2, -2)
 elseif modules.corelib.g_keyboard.isKeyPressed('d') or modules.corelib.g_keyboard.isKeyPressed('Right') or modules.corelib.g_keyboard.isKeyPressed('numpad6') then
  checkPos(3, 0)
 elseif modules.corelib.g_keyboard.isKeyPressed('c') then
  checkPos(2, 2)
 elseif modules.corelib.g_keyboard.isKeyPressed('s') or modules.corelib.g_keyboard.isKeyPressed('Down') or modules.corelib.g_keyboard.isKeyPressed('numpad2') then
  checkPos(0, 3)
 elseif modules.corelib.g_keyboard.isKeyPressed('z') then
  checkPos(-2, 2)
 elseif modules.corelib.g_keyboard.isKeyPressed('a') or modules.corelib.g_keyboard.isKeyPressed('Left') or modules.corelib.g_keyboard.isKeyPressed('numpad4') then
  checkPos(-3, 0)
 elseif modules.corelib.g_keyboard.isKeyPressed('q') then
  checkPos(-2, -2)
 end
end)

--Jump Up/Down
local usingWASD = modules.game_walking.wsadWalking
local walkDir
onKeyDown(function(keys)
  usingWASD = modules.game_walking.wsadWalking
  if usingWASD then
    if keys == "D" or keys == "A" or keys == "S" or keys == "W" then
      walkDir = keys
    end
  else
    if keys == "Up" or keys == "Right" or keys == "Down" or keys == "Left" then
      walkDir = keys
    end
  end
end)

jump = macro(100, "Jump", ('CTRL+4'), function()
  local playerPos = pos()
  local levitateTile
  if walkDir == "W" or walkDir == "Up" then -- north
    playerPos.y = playerPos.y - 1
    turn(0)
    levitateTile = g_map.getTile(playerPos)
  elseif walkDir == "D" or walkDir == "Right" then -- east
    playerPos.x = playerPos.x + 1
    turn(1)
    levitateTile = g_map.getTile(playerPos)
  elseif walkDir == "S" or walkDir == "Down" then -- south
    playerPos.y = playerPos.y + 1
    turn(2)
    levitateTile = g_map.getTile(playerPos)
  elseif walkDir == "A" or walkDir == "Left" then -- west
    playerPos.x = playerPos.x - 1
    turn(3)
    levitateTile = g_map.getTile(playerPos)
  end

  if levitateTile and not levitateTile:isWalkable() then
    if levitateTile:getGround() then
      say('jump "up')
      walkDir = nil
    else
      say('jump "down')
      walkDir = nil
    end
  end
  walkDir = nil
  end)
UI.Separator()

UI.Label("-- Combat --"):setColor('#EBDAA2')
--spell de debuff
macro(100, "Spell de Debuff", function()   
if g_game.isAttacking() and storage.spelldebuff:len() > 1 then
        say(storage.spelldebuff)
		delay(61000)
    end 
end)
UI.TextEdit(storage.spelldebuff or "magia", function(widget, text)    
  storage.spelldebuff = text
end)

 --auto area spell
spellarea = macro(200, "Spell Area", function() 
if g_game.isAttacking() and storage.autospellarea:len() > 1 then
        say(storage.autospellarea)
    end 
end)
UI.TextEdit(storage.autospellarea or "magia de area", function(widget, text)    
  storage.autospellarea	 = text
end)
addIcon("Area", {item=16051, movable=true, text="Area"},spellarea)
UI.Separator()


UI.Label("-- Combos --"):setColor('#EBDAA2')
--editor de combos
UI.Button("Editor de Combos", function(newText)
    UI.MultilineEditorWindow(storage.editordecombos or "", {title="Editor de Combos", description="Coloque seus combos abaixo"}, function(text)
      storage.editordecombos = text
      reload()
    end)
  end)
  
  for _, scripts in pairs({storage.editordecombos}) do
    if type(scripts) == "string" and scripts:len() > 3 then
      local status, result = pcall(function()
        assert(load(scripts, "editordecombos"))()
      end)
      if not status then 
        error("Ingame edior error:\n" .. result)
      end
    end
  end
UI.Separator()