--------------------------------------------------------------------------------
-- Icon lookup for the Crylia widgets, adapted to NixOS icon locations.
--
-- The upstream version hardcodes /usr/share/icons/<theme>/<res>/apps/. NixOS
-- keeps icons in the XDG data dirs and WhiteSur uses apps/<size>/ as well, so
-- this version searches both layouts and a list of roots.
--------------------------------------------------------------------------------
local home = os.getenv("HOME")
local user = os.getenv("USER") or ""

local roots = {
  home .. "/.local/share/icons",
  home .. "/.nix-profile/share/icons",
  home .. "/.local/state/nix/profile/share/icons",
  "/etc/profiles/per-user/" .. user .. "/share/icons",
  "/run/current-system/sw/share/icons",
  "/usr/share/icons",
}

local resolutions = { "scalable", "128x128", "96x96", "64x64", "48x48", "32x32", "24x24", "16x16" }

-- Names that exist in the icon theme under a different file name.
local aliases = {
  ["brave-browser.svg"] = "brave-bin.svg",
  ["brave.svg"]        = "brave-bin.svg",
  ["org.gnome.nautilus.svg"] = "org.gnome.Nautilus.svg",
  ["nautilus.svg"]     = "org.gnome.Nautilus.svg",
}

local icon_cache = {}

local function exists(path)
  local f = io.open(path, "r")
  if f then
    f:close()
    return true
  end
  return false
end

local function lookup_name(theme, name)
  if not name or name == "" then return nil end
  name = aliases[name] or name
  for _, root in ipairs(roots) do
    for _, res in ipairs(resolutions) do
      -- layout 1: <theme>/<res>/apps/<name>
      local p = root .. "/" .. theme .. "/" .. res .. "/apps/" .. name
      if exists(p) then return p end
      -- layout 2: <theme>/apps/<res>/<name>
      p = root .. "/" .. theme .. "/apps/" .. res .. "/" .. name
      if exists(p) then return p end
    end
  end
  return nil
end

local function lookup(theme, name)
  local hit = lookup_name(theme, name)
  if hit then return hit end
  -- fall back to hicolor, where application icons are usually found
  if theme ~= "hicolor" then
    hit = lookup_name("hicolor", name)
    if hit then return hit end
  end
  return nil
end

local function fallback()
  return lookup("WhiteSur-dark", "application-default-icon.svg")
      or lookup("hicolor", "application-x-executable.svg")
      or ""
end

-- Tries to find an icon for a client, a program string or a class string.
function Get_icon(theme, client, program_string, class_string, is_steam)
  client        = client or nil
  program_string = program_string or nil
  class_string  = class_string or nil
  is_steam      = is_steam or nil

  if not theme or not (client or program_string or class_string) then
    return nil
  end

  local candidates = {}

  if is_steam then
    table.insert(candidates, "steam_icon_" .. tostring(client) .. ".svg")
  elseif client then
    if client.class then
      local c = client.class:gsub(" ", "")
      table.insert(candidates, string.lower(c) .. ".svg")
      table.insert(candidates, c .. ".svg")
    end
    if client.icon and client.icon ~= "" then
      if exists(tostring(client.icon)) then return tostring(client.icon) end
    end
  else
    if program_string then
      table.insert(candidates, program_string .. ".svg")
      table.insert(candidates, string.lower(program_string) .. ".svg")
      table.insert(candidates, program_string:gsub("^%l", string.upper) .. ".svg")
    end
    if class_string then
      table.insert(candidates, class_string .. ".svg")
      table.insert(candidates, string.lower(class_string) .. ".svg")
    end
  end

  for _, name in ipairs(candidates) do
    if icon_cache[name] then
      return icon_cache[name]
    end
    local hit = lookup(theme, name)
    if hit then
      icon_cache[name] = hit
      return hit
    end
  end

  return fallback()
end
