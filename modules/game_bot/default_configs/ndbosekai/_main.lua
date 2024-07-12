UI.Separator()


-- AUTO REVIDE / FIGHT BACK / ATTACK PLAYER PK (REVIDAR)

setDefaultTab("Main")

-- vBot scripting services: F.Almeida#8019
-- if you like it, consider making a donation:
-- https://www.paypal.com/donate/?business=8XSU4KTS2V9PN&no_recurring=0&item_name=OTC+AND+OTS+SCRIPTS&currency_code=USD

-- ATTENTION:
-- Don't edit below this line unless you know what you're doing.
-- ATENÇÃO:
-- Não mexa em nada daqui para baixo, a não ser que saiba o que está fazendo.
-- ATENCIÓN:
-- No cambies nada desde aquí, solamente si sabes lo que estás haciendo.

local ignoreEmblems = {1,4} -- Guild Emblems (Allies)

local ui = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    !text: tr('Fight Back (Revide)')
    font: verdana-11px-rounded

  Button
    id: edit
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Setup
    font: verdana-11px-rounded
]])

local edit = setupUI([[
RevideBox < CheckBox
  font: verdana-11px-rounded
  margin-top: 5
  margin-left: 5
  anchors.top: prev.bottom
  anchors.left: parent.left
  anchors.right: parent.right
  color: lightGray

Panel
  height: 123

  RevideBox
    id: pauseTarget
    anchors.top: parent.top
    text: Pause TargetBot 
    !tooltip: tr('Pause TargetBot While fighting back.')

  RevideBox
    id: pauseCave
    text: Pause CaveBot 
    !tooltip: tr('Pause CaveBot While fighting back.')

  RevideBox
    id: followTarget
    text: Follow Target 
    !tooltip: tr('Set Chase Mode to Follow While fighting back.')

  RevideBox
    id: ignoreParty
    text: Ignore Party Members

  RevideBox
    id: ignoreGuild
    text: Ignore Guild Members

  RevideBox
    id: attackAll
    text: Attack All Skulled
    !tooltip: tr("Attack every skulled player, even if he didn't attacked you.")

  BotTextEdit
    id: esc
    width: 83
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    text: Escape
    color: red
    font: verdana-11px-rounded

  Label
    text: Cancel Attack:
    font: verdana-11px-rounded
    anchors.left: parent.left
    margin-left: 5
    anchors.verticalCenter: esc.verticalCenter
]])
edit:hide()

local showEdit = false
ui.edit.onClick = function(widget)
  showEdit = not showEdit
  if showEdit then
    edit:show()
  else
    edit:hide()
  end
end
-- End Basic UI

-- Storage
local st = "RevideFight"
storage[st] = storage[st] or {
  enabled = false,
  pauseTarget = true,
  pauseCave = true,
  followTarget = true,
  ignoreParty = false,
  ignoreGuild = false,
  attackAll = false,
  esc = "Escape",
}
local config = storage[st]

-- UI Functions
-- Main Button
ui.title:setOn(config.enabled)
ui.title.onClick = function(widget)
  config.enabled = not config.enabled
  widget:setOn(config.enabled)
end

-- Checkboxes
do
  edit.pauseTarget:setChecked(config.pauseTarget)
  edit.pauseTarget.onClick = function(widget)
    config.pauseTarget = not config.pauseTarget
    widget:setChecked(config.pauseTarget)
    widget:setImageColor(config.pauseTarget and "green" or "red")
  end
  edit.pauseTarget:setImageColor(config.pauseTarget and "green" or "red")
  
  edit.pauseCave:setChecked(config.pauseCave)
  edit.pauseCave.onClick = function(widget)
    config.pauseCave = not config.pauseCave
    widget:setChecked(config.pauseCave)
    widget:setImageColor(config.pauseCave and "green" or "red")
  end
  edit.pauseCave:setImageColor(config.pauseCave and "green" or "red")

  edit.followTarget:setChecked(config.followTarget)
  edit.followTarget.onClick = function(widget)
    config.followTarget = not config.followTarget
    widget:setChecked(config.followTarget)
    widget:setImageColor(config.followTarget and "green" or "red")
  end
  edit.followTarget:setImageColor(config.followTarget and "green" or "red")

  edit.ignoreParty:setChecked(config.ignoreParty)
  edit.ignoreParty.onClick = function(widget)
    config.ignoreParty = not config.ignoreParty
    widget:setChecked(config.ignoreParty)
    widget:setImageColor(config.ignoreParty and "green" or "red")
  end
  edit.ignoreParty:setImageColor(config.ignoreParty and "green" or "red")

  edit.ignoreGuild:setChecked(config.ignoreGuild)
  edit.ignoreGuild.onClick = function(widget)
    config.ignoreGuild = not config.ignoreGuild
    widget:setChecked(config.ignoreGuild)
    widget:setImageColor(config.ignoreGuild and "green" or "red")
  end
  edit.ignoreGuild:setImageColor(config.ignoreGuild and "green" or "red")

  edit.attackAll:setChecked(config.attackAll)
  edit.attackAll.onClick = function(widget)
    config.attackAll = not config.attackAll
    widget:setChecked(config.attackAll)
    widget:setImageColor(config.attackAll and "green" or "red")
  end
  edit.attackAll:setImageColor(config.attackAll and "green" or "red")
end

-- TextEdit
edit.esc:setText(config.esc)
edit.esc.onTextChange = function(widget, text)
  config.esc = text
end
edit.esc:setTooltip("Hotkey to cancel attack.")

-- End of setup.

local target = nil
local c = config

-- Main Loop
macro(250, function()
  if not c.enabled then return end
  if not target then
    if c.pausedTarget then
      c.pausedTarget = false
      TargetBot.setOn()
    end
    if c.pausedCave then
      c.pausedCave = false
      CaveBot.setOn()
    end
    -- Search for attackers
    local creatures = getSpectators(false)
    for s, spec in ipairs(creatures) do
      if spec ~= player and spec:isPlayer() then
        if (c.attackAll and spec:getSkull() > 2) or spec:isTimedSquareVisible() then
          if c.ignoreParty or spec:getShield() < 3 then
            if c.ignoreGuild or not table.find(ignoreEmblems, spec:getEmblem()) then
              target = spec:getName()
              break
            end
          end
        end
      end
    end
    return
  end

  local creature = getPlayerByName(target)
  if not creature then target = nil return end
  if c.pauseTargetBot then
    c.pausedTarget = true
    TargetBot.setOff()
  end
  if c.pauseTarget then
    c.pausedTarget = true
    TargetBot.setOff()
  end
  if c.pauseCave then
    c.pausedCave = true
    CaveBot.setOff()
  end

  if c.followTarget then
    g_game.setChaseMode(2)
  end

  if g_game.isAttacking() then
    if g_game.getAttackingCreature():getName() == target then
      return
    end
  end
  g_game.attack(creature)
end)

onKeyDown(function(keys)
  if not c.enabled then return end
  if keys == config.esc then
    target = nil
  end
end)

UI.Separator()

UI.Separator()

macro(1000, "Main BP Open", function()
    bpItem = getBack()
    bp = getContainer(0)

    if not bp and bpItem ~= nil then
        g_game.open(bpItem)
    end

end)

gpPushEnabled = false
gpPushDelay = 600 -- safe value: 600ms

local switch = addSwitch("gpPushEnabled", "Push Redor p/ Baixo", function(widget)
    widget:setOn(not widget:isOn())
    gpPushEnabled = widget:isOn()
end, tab)

macro(gpPushDelay, function ()
    if gpPushEnabled then
        push(0, -1, 0)
        push(0, 1, 0)
        push(-1, -1, 0)
        push(-1, 0, 0)
        push(-1, 1, 0)
        push(1, -1, 0)
        push(1, 0, 0)
        push(1, 1, 0)
    end
end)

function push(x, y, z)
    local position = player:getPosition()
    position.x = position.x + x
    position.y = position.y + y
  
    local tile = g_map.getTile(position)
    local thing = tile:getTopThing()
    if thing and thing:isItem() then
      g_game.move(thing, player:getPosition(), thing:getCount())
    end
end

macro(10000, "Anti Kick",  function()
  local dir = player:getDirection()
  turn((dir + 1) % 4)
  turn(dir)
end)

local moneyIds = {3031, 3035, 3043} -- gold coin, platinium coin, cristal coin
macro(1000, "Trocar Golds", function()
  local containers = g_game.getContainers()
  for index, container in pairs(containers) do
    if not container.lootContainer then -- ignore monster containers
      for i, item in ipairs(container:getItems()) do
        if item:getCount() == 100 then
          for m, moneyId in ipairs(moneyIds) do
            if item:getId() == moneyId then
              return g_game.use(item)            
            end
          end
        end
      end
    end
  end
end)

UI.Separator()
UI.Label("Auto Follow Name")
addTextEdit("followleader", storage.followLeader or "player name", function(widget, text)
storage.followLeader = text
end)
--Code
local toFollowPos = {}
local followMacro = macro(20, "Follow", function()
local target = getCreatureByName(storage.followLeader)
if target then
local tpos = target:getPosition()
toFollowPos[tpos.z] = tpos
end
if player:isWalking() then return end
local p = toFollowPos[posz()]
if not p then return end
if autoWalk(p, 20, {ignoreNonPathable=true, precision=1}) then
delay(100)
end
end)
onCreaturePositionChange(function(creature, oldPos, newPos)
if creature:getName() == storage.followLeader then
toFollowPos[newPos.z] = newPos
end
end)

UI.Separator()

local creatureId = nil;
local stopAttackRequested = false

keepTarget = {
  setTarget = function(_creatureId)
    creatureId = _creatureId
  end,

  stopAttack = function()
    stopAttackRequested = true
  end
}


local toFollow = "nick" -- nome do jogador 
local toFollowPos = {nick}

local followMacro = macro(200, "follow target", function()
  local target = getCreatureByName(toFollow)
  if target then
    local tpos = target:getPosition()
    toFollowPos[tpos.z] = tpos
  end
  if player:isWalking() then return end
  local p = toFollowPos[posz()]
  if not p then return end
  if autoWalk(p, 20, {ignoreNonPathable=true, precision=1}) then
    delay(100)
  end
end)

onCreaturePositionChange(function(creature, oldPos, newPos)
  if creature:getName() == toFollow then
    toFollowPos[newPos.z] = newPos
  end
end)


macro(1, "Enemy", function()
 for _,pla in ipairs(getSpectators(posz())) do
 attacked = g_game.getAttackingCreature()
  if (not attacked or (attacked and (not attacked:isPlayer() or (pla:getHealthPercent() < attacked:getHealthPercent())))) and pla:isPlayer() and pla:getEmblem() ~= 1 then 
   g_game.attack(pla)
  end
 end
end)



keepTarget.macro = macro(1, "Attack Target", function()
  if g_game.getFollowingCreature() then
    keepTarget.stopAttack()
  end

  local creature = g_game.getAttackingCreature()

  if creature and creatureId ~= creature:getId() then
    keepTarget.setTarget(creature:getId())
  end

  if creatureId and not creature and not stopAttackRequested then
    local target = getCreatureById(creatureId)
    if target and CaveBot.isOff() then
      attack(target)
    end

  elseif stopAttackRequested then
    creatureId = nil
    g_game.cancelAttack()
    stopAttackRequested = false
  end
end)

onKeyUp(function(keys)
    if keys == "Escape" then
      keepTarget.stopAttack()
    end
  end)

macro(1, "Atacar Bichos", function() 
  local battlelist = getSpectators();
  local closest = 12
  local lowesthpc = 101
  for key, val in pairs(battlelist) do
    if val:isMonster() then
      if getDistanceBetween(player:getPosition(), val:getPosition()) <= closest then
        closest = getDistanceBetween(player:getPosition(), val:getPosition())
        if val:getHealthPercent() < lowesthpc then
          lowesthpc = val:getHealthPercent()
        end
      end
    end
  end
  for key, val in pairs(battlelist) do
    if val:isMonster() then
      if getDistanceBetween(player:getPosition(), val:getPosition()) <= closest then
        if g_game.getAttackingCreature() ~= val and val:getHealthPercent() <= lowesthpc then 
          g_game.attack(val)
	delay(100)
          break
        end
      end
    end
  end
end)

UI.Separator()
UI.Separator()



local showhp = macro(20000, "Monstro Hp %", function() end)
onCreatureHealthPercentChange(function(creature, healthPercent)
    if showhp:isOff() then  return end
    if creature:isMonster() or creature:isPlayer() and creature:getPosition() and pos() then
        if getDistanceBetween(pos(), creature:getPosition()) <= 5 then
            creature:setText(healthPercent .. "%")
        else
            creature:clearText()
  

      end
    end
end)

UI.Separator ()

macro(1000, "Juntar itens", function()
  local containers = g_game.getContainers()
  local toStack = {}
  for index, container in pairs(containers) do
    if not container.lootContainer then -- ignore monster containers
      for i, item in ipairs(container:getItems()) do
        if item:isStackable() and item:getCount() < 100 then
          local stackWith = toStack[item:getId()]
          if stackWith then
            g_game.move(item, stackWith[1], math.min(stackWith[2], item:getCount()))
            return
          end
          toStack[item:getId()] = {container:getSlotPosition(i - 1), 100 - item:getCount()}
        end
      end
    end
  end
end)

UI.Separator()

macro(250, "Atacar Seguindo", "Shift+R", function()
   if g_game.isOnline() and g_game.isAttacking() then
         g_game.setChaseMode(1)
           end
           end)

UI.Separator()

macro(1000, "Abrir proxima Bag", function()
  local containers = getContainers()
  for i, container in pairs(containers) do
    if container:getItemsCount() == container:getCapacity() then
      for _, item in ipairs(container:getItems()) do
        if item:isContainer() then
          g_game.open(item, container)
        end
      end
    end
  end
end)

UI.Separator()

local pt = false
addSwitch("pt", "Auto PT = falar pt", function(widget)
    pt = not pt
    widget:setOn(pt)
end)

macro(1000,"Auto Accept Party",function() 
  if player:getShield() > 2 then return end -- already in a party
  for s, spec in pairs(getSpectators(false)) do
    if spec:getShield() == 1 then
      g_game.partyJoin(spec:getId())
      delay(1000)
    end
  end
end)

UI.Separator()

onTalk(function(name, level, mode, text, channelId, pos)
if name == player:getName() then return end
    if mode ~= 1 then  return end
    if string.find(text, "pt")  and pt == true then
        local friend = getPlayerByName(name)
        g_game.partyInvite(friend:getId())
    end
end)

UI.Separator()

macro(1000, "Abrir Bag Principal", function()
    bpItem = getBack()
    bp = getContainer(0)

    if not bp and bpItem ~= nil then
        g_game.open(bpItem)
    end

end)
UI.Separator()


if type(storage.moneyItems) ~= "table" then
  storage.moneyItems = {3031, 3035}
end
macro(1000, "Converter dinheiro", function()
  if not storage.moneyItems[1] then return end
  local containers = g_game.getContainers()
  for index, container in pairs(containers) do
    if not container.lootContainer then -- ignore monster containers
      for i, item in ipairs(container:getItems()) do
        if item:getCount() == 100 then
          for m, moneyId in ipairs(storage.moneyItems) do
            if item:getId() == moneyId.id then
              return g_game.use(item)
            end
          end
        end
      end
    end
  end
end)

local moneyContainer = UI.Container(function(widget, items)
  storage.moneyItems = items
end, true)
moneyContainer:setHeight(35)
moneyContainer:setItems(storage.moneyItems)
UI.Separator()

local afkMsg = false
addSwitch("afkMsg", "Responder PM AFK", function(widget)
    afkMsg = not afkMsg
    widget:setOn(afkMsg)
end)

onTalk(function(name, level, mode, text, channelId, pos) --quando receber uma pm vai responder com a mensagem escolhida abaixo
    if mode == 4 and afkMsg == true then
        g_game.talkPrivate(5, name, storage.afkMsg)
        delay(5000)
    end
end)
UI.TextEdit(storage.afkMsg or "MENSAGEM", function(widget, newText)
storage.afkMsg = newText
end)

UI.Separator()

macro(60000, "Msg trade", function()
  local Trade = getChannelId("advertising")
  if not Trade then
    Trade = getChannelId("Trade")
  end
  if Trade and storage.autoTradeMessage:len() > 0 then    
    sayChannel(Trade, storage.autoTradeMessage)
  end
end)
UI.TextEdit(storage.autoTradeMessage or "hi ", function(widget, text)    
  storage.autoTradeMessage = text
end)

UI.Separator()
macro(60000, "Msg Help", function()
  local Help = getChannelId("advertising")
  if not Help then
    Help = getChannelId("Help")
  end
  if Help and storage.autoHelpMessage:len() > 0 then    
    sayChannel(Help, storage.autoHelpMessage)
  end
end)
UI.TextEdit(storage.autoHelpMessage or "hi", function(widget, text)    
  storage.autoHelpMessage = text
end)

UI.Separator()