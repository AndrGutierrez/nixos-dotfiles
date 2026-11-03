-----------------------------------
-- This is the titlebar module --
-----------------------------------

-- Awesome Libs
local awful = require("awful")
local color = require("src.theme.colors")
local dpi = require("beautiful").xresources.apply_dpi
local gears = require("gears")
local wibox = require("wibox")
require("src.core.signals")
require("src.tools.icon_handler")

-- Icon directory path
local icondir = awful.util.getdir("config") .. "src/assets/icons/titlebar/"

awful.titlebar.enable_tooltip = true
awful.titlebar.fallback_name = 'Client'

local double_click_event_handler = function(double_click_event)
  if double_click_timer then
    double_click_timer:stop()
    double_click_timer = nil
    double_click_event()
    return
  end
  double_click_timer = gears.timer.start_new(
    0.20,
    function()
      double_click_timer = nil
      return false
    end
  )
end

local create_click_events = function(c)
  local buttons = gears.table.join(
    awful.button(
      {},
      1,
      function()
        double_click_event_handler(function()
          if c.floating then
            c.float = false
            return
          end
          c.maximized = not c.maximized
          c:raise()
        end)
        c:activate { context = 'titlebar', action = 'mouse_move' }
      end
    ),
    awful.button(
      {},
      3,
      function()
        c:activate { context = 'titlebar', action = 'mouse_resize' }
      end
    )
  )
  return buttons
end

local create_titlebar = function(c, bg, size)
  local titlebar = awful.titlebar(c, {
    position = "left",
    bg = bg,
    size = size
  })

  titlebar:setup {
    {
      {
        {
          awful.titlebar.widget.closebutton(c),
          widget = wibox.container.background,
          bg = color["TrafficRed"],
          shape = function(cr, height, width)
            gears.shape.rounded_rect(cr, width, height, 4)
          end,
          id = "closebutton"
        },
        {
          awful.titlebar.widget.maximizedbutton(c),
          widget = wibox.container.background,
          bg = color["TrafficYellow"],
          shape = function(cr, height, width)
            gears.shape.rounded_rect(cr, width, height, 4)
          end,
          id = "maximizebutton"
        },
        {
          awful.titlebar.widget.minimizebutton(c),
          widget = wibox.container.background,
          bg = color["TrafficGreen"],
          shape = function(cr, height, width)
            gears.shape.rounded_rect(cr, width, height, 4)
          end,
          id = "minimizebutton"
        },
        spacing = dpi(10),
        layout  = wibox.layout.fixed.vertical,
        id      = "spacing"
      },
      margins = dpi(8),
      widget = wibox.container.margin,
      id = "margin"
    },
    {
      buttons = create_click_events(c),
      layout = wibox.layout.flex.vertical
    },
    {
      {
        image = Get_icon(user_vars.icon_theme, c),
        resize = true,
        forced_width = dpi(22),
        forced_height = dpi(22),
        widget = wibox.widget.imagebox,
      },
      margins = dpi(5),
      widget = wibox.container.margin
    },
    layout = wibox.layout.align.vertical,
    id = "main"
  }
  Hover_signal(titlebar.main.margin.spacing.closebutton, color["TrafficRed"], color["Grey900"])
  Hover_signal(titlebar.main.margin.spacing.maximizebutton, color["TrafficYellow"], color["Grey900"])
  Hover_signal(titlebar.main.margin.spacing.minimizebutton, color["TrafficGreen"], color["Grey900"])
end

local create_titlebar_dialog = function(c, bg, size)
  local titlebar = awful.titlebar(c, {
    position = "left",
    bg = bg,
    size = size
  })

  titlebar:setup {
    {
      {
        {
          awful.titlebar.widget.closebutton(c),
          widget = wibox.container.background,
          bg = color["TrafficRed"],
          shape = function(cr, height, width)
            gears.shape.rounded_rect(cr, width, height, 4)
          end,
          id = "closebutton"
        },
        {
          awful.titlebar.widget.minimizebutton(c),
          widget = wibox.container.background,
          bg = color["TrafficGreen"],
          shape = function(cr, height, width)
            gears.shape.rounded_rect(cr, width, height, 4)
          end,
          id = "minimizebutton"
        },
        spacing = dpi(10),
        layout  = wibox.layout.fixed.vertical,
        id      = "spacing"
      },
      margins = dpi(8),
      widget = wibox.container.margin,
      id = "margin"
    },
    {
      buttons = create_click_events(c),
      layout = wibox.layout.flex.vertical
    },
    {
      {
        image = Get_icon(user_vars.icon_theme, c),
        resize = true,
        forced_width = dpi(22),
        forced_height = dpi(22),
        widget = wibox.widget.imagebox,
      },
      margins = dpi(5),
      widget = wibox.container.margin
    },
    layout = wibox.layout.align.vertical,
    id = "main"
  }
  Hover_signal(titlebar.main.margin.spacing.closebutton, color["TrafficRed"], color["Grey900"])
  Hover_signal(titlebar.main.margin.spacing.minimizebutton, color["TrafficGreen"], color["Grey900"])
end

local draw_titlebar = function(c)
  -- ignore Motif 'no decorations' hints (CSD apps like Nautilus):
  -- the left titlebar is our window chrome.
  if c.type == 'normal' then
    if c.class == 'Firefox' then
      create_titlebar(c, '#2f223aAA', 35)
    elseif c.name == "Steam" then
      create_titlebar(c, '#2f223aAA', 0)
    elseif c.name == "Settings" then
      create_titlebar(c, '#2f223aAA', 0)
    elseif c.class == "gcr-prompter" or c.class == "Gcr-prompter" then
      create_titlebar(c, '#2f223aAA', 0)
    else
      create_titlebar(c, '#2f223aAA', 35)
    end
  elseif c.type == 'dialog' then
    create_titlebar_dialog(c, '#2f223aAA', 35)
  end
end

client.connect_signal(
  "property::maximized",
  function(c)
    if c.maximized then
      Theme.titlebar_maximized_button_normal = icondir .. "unmaximize.svg"
      Theme.titlebar_maximized_button_active = icondir .. "unmaximize.svg"
      Theme.titlebar_maximized_button_inactive = icondir .. "unmaximize.svg"
    elseif not c.minimized then
      Theme.titlebar_maximized_button_normal = icondir .. "maximize.svg"
      Theme.titlebar_maximized_button_active = icondir .. "maximize.svg"
      Theme.titlebar_maximized_button_inactive = icondir .. "maximize.svg"
    end
  end
)

client.connect_signal(
  "request::titlebars",
  function(c)
    if c.maximized then
      Theme.titlebar_maximized_button_normal = icondir .. "unmaximize.svg"
      Theme.titlebar_maximized_button_active = icondir .. "unmaximize.svg"
      Theme.titlebar_maximized_button_inactive = icondir .. "unmaximize.svg"
      draw_titlebar(c)
    elseif not c.minimized then
      Theme.titlebar_maximized_button_normal = icondir .. "maximize.svg"
      Theme.titlebar_maximized_button_active = icondir .. "maximize.svg"
      Theme.titlebar_maximized_button_inactive = icondir .. "maximize.svg"
      draw_titlebar(c)
    end
  end
)

-- Titlebars are always shown (left side, macOS style). The upstream theme
-- hid them for tiled clients; we keep them visible for every normal window.

