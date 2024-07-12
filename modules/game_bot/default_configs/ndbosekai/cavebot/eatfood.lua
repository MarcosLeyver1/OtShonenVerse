--auto eat food
macro(30000, "Auto Eat Food", function()
if g_game.isOnline() then
use(storage.autoeatfood)
end
end)
UI.TextEdit(storage.autoeatfood or "id da food", function(widget, text)    
  storage.autoeatfood	 = text
end)
UI.Separator()