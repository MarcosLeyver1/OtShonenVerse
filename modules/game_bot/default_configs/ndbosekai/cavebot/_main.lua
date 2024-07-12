UI.Separator()
UI.Label("SmkCarlao#1328"):setColor('#EBDAA2')
UI.Label("Presents;"):setColor('#EBDAA2')
UI.Separator()

--editor de especiais
UI.Button("Especiais/Revives", function(newText)
    UI.MultilineEditorWindow(storage.especiaisrevives or "", {title="Editor de Especiais", description="Aqui voce pode editar os seus especiais."}, function(text)
      storage.especiaisrevives = text
      reload()
    end)
  end)
  
UI.Separator()
  
  for _, scripts in pairs({storage.especiaisrevives}) do
    if type(scripts) == "string" and scripts:len() > 3 then
      local status, result = pcall(function()
        assert(load(scripts, "especiaisrevives"))()
      end)
      if not status then 
        error("Ingame edior error:\n" .. result)
      end
    end
  end

--esconder msgs inv
macro(1000, "Esconder Spells Laranja", function()
onStaticText(function(thing, text)
    if not text:find('says:') then
        g_map.cleanTexts()
    end
end)
end)
UI.Separator()

--sense
sensee = macro(200, " Sense - Target & Name", function()
if storage.sense:len() > 1 then
say('sense "'.. storage.sense)
delay(5000)
end
if g_game.isAttacking() and g_game.getAttackingCreature():isPlayer() then
sense = g_game.getAttackingCreature():getName()
storage.sense = sense
delay(5000) 
end
end)
UI.TextEdit(storage.sense or "", function(widget, text)    
storage.sense = text
end)
addIcon("Sense", {item=16054, movable=true, text="Sense"},sensee) 
UI.Separator()

--start/stop CaveBot
macro(1, "Start/Stop CaveBot", ("CTRL+1"), function(killcave)
if CaveBot.isOn() then
 CaveBot.setOff()
 killcave.setOff()
else
 CaveBot.setOn()
 killcave.setOff()
end
end)
UI.Separator()

--start/stop TargetBot
macro(1, "Start/Stop TargetBot", ("CTRL+2"), function(killtarget)
if TargetBot.isOn() then
 TargetBot.setOff()
 killtarget.setOff()
else
 TargetBot.setOn()
 killtarget.setOff()
end
end)
UI.Separator()

 --bless
 if player:getBlessings() == 0 then
    say("!bless")
	say("!frags")
    schedule(500, function()
        if player:getBlessings() == 0 then
            error("~~ BLESS ATIVO ~~")
        end
    end)
end