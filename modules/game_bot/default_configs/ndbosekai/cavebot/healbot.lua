setDefaultTab("HP")
UI.Separator()
UI.Label("-- Healing --"):setColor('#EBDAA2')
--fast hp pot guild members
macro(100, "Potion Guild: HP < 75%",function()
  if g_game.isOnline() then
  local p = g_game.getLocalPlayer()
  if p:getHealth()/p:getMaxHealth() > 0.5 then
  for i,v in pairs(g_map.getSpectators(p:getPosition())) do 
  if v:getId() ~= p:getId() and v:getHealthPercent() <= 75 and (v:getShield() == 3 or v:getEmblem() == 1) then 
  g_game.useInventoryItemWith(storage.idpotally, v)
  end
  end
  end 
  end 
  end)
  UI.TextEdit(storage.idpotally or "id da potion", function(widget, text)    
  storage.idpotally = text
end)

--fast potion
potionn = macro(50,"Self Potion: HP < 75%", function()
if storage.autosenzumelhorada:len() > 1 and hppercent() <= 75 then
	g_game.useInventoryItemWith(storage.autosenzumelhorada, player)
	delay(1000)
end
end)
UI.TextEdit(storage.autosenzumelhorada or "id da potion", function(widget, text)    
  storage.autosenzumelhorada = text
end)
addIcon("Potion", {item=13545, movable=true, text="Potion"},potionn)   

--fast big regen
healingg = macro(50,"Healing Spell: HP < 99%", function()
if hppercent() <= 99 and storage.autohealspell1:len() > 1 then
	say(storage.autohealspell1)
end
end)
UI.TextEdit(storage.autohealspell1 or "", function(widget, text)    
  storage.autohealspell1 = text
end)
addIcon("Healing", {item=13545, movable=true, text="Healing"},healingg) 
UI.Separator()

--buffs e haste
UI.Label("-- Buffs & Haste --"):setColor('#EBDAA2')
buffs = macro(50,"Buff", function()
if not hasHaste() and storage.autohastespell:len() > 1 then
say(storage.autohastespell)
delay(100)
elseif hasPartyBuff() and storage.autobuff1:len() > 1 then
say(storage.autobuff1)
say(storage.autobuff2)
say(storage.autobuff3)
delay(25500)
end
end)
UI.TextEdit(storage.autobuff1 or "", function(widget, text)    
  storage.autobuff1 = text
end)
UI.TextEdit(storage.autobuff2 or "", function(widget, text)    
  storage.autobuff2 = text
end)
UI.TextEdit(storage.autobuff3 or "", function(widget, text)    
  storage.autobuff3 = text
end)
UI.Label("Haste"):setColor('#EBDAA2')
UI.TextEdit(storage.autohastespell or "", function(widget, text)    
  storage.autohastespell = text
end)
addIcon("Buffs", {item=14950, movable=true, text="Buffs"},buffs) 
UI.Separator()