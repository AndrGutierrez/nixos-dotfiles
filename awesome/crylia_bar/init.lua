--- Crylia bars (vendored subset).
--
-- Adds the three floating top bars (left / center / right) and the bottom
-- dock. Tags, keybindings, rules, monitors and the compositor stay in rc.lua.
return function(s)
  local layoutlist = require("src.widgets.layout_list")(s)
  local taglist    = require("src.widgets.taglist")(s)
  local tasklist   = require("src.widgets.tasklist")(s)
  local audio      = require("src.widgets.audio")(s)
  local kblayout   = require("src.widgets.kblayout")(s)
  local date       = require("src.widgets.date")()
  local clock      = require("src.widgets.clock")()
  local power      = require("src.widgets.power")()

  -- The power button emits "module::powermenu:show"; this popup handles it.
  require("src.modules.powermenu")(s)

  local left = { layoutlist, taglist }
  if s.index == 1 then
    local systray = require("src.widgets.systray")(s)
    table.insert(left, 2, systray)
  end

  require("crylia_bar.left_bar")(s, left)
  require("crylia_bar.center_bar")(s, { tasklist })
  require("crylia_bar.right_bar")(s, { audio, kblayout, date, clock, power })
  require("crylia_bar.dock")(s, user_vars.dock_programs)
end
