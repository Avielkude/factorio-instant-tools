-- Instant Tools
-- Batch destroy / copy / move with optional container contents,
-- ghost preview, rotation, undo and map planning zones.

local function give(player, name, count)
  if not name or not count or count <= 0 then return end
  pcall(function() player.insert{ name = name, count = count } end)
end

-- ================= destroy =================

local function refund_items_to_place(player, entity)
  local proto = entity.prototype
  if not proto then return end
  local items = proto.items_to_place_this
  if items then
    for _, stack in pairs(items) do give(player, stack.name, stack.count) end
  end
end

local function refund_inventories(player, entity)
  local inv_ids = {
    defines.inventory.chest,
    defines.inventory.fuel,
    defines.inventory.item_main,
    defines.inventory.crafting,
    defines.inventory.modules,
  }
  for _, inv_id in pairs(inv_ids) do
    local inv = nil
    pcall(function() inv = entity.get_inventory(inv_id) end)
    if inv and inv.valid then
      local ok, contents = pcall(function() return inv.get_contents() end)
      if ok and contents then
        for _, item in pairs(contents) do give(player, item.name, item.count) end
      end
    end
  end
end

local function refund_belt_contents(player, entity)
  if entity.type ~= "transport-belt" and entity.type ~= "underground-belt" and entity.type ~= "splitter" then
    return
  end
  for i = 1, 2 do
    local ok, line = pcall(function() return entity.get_transport_line(i) end)
    if ok and line and line.valid then
      local ok2, contents = pcall(function() return line.get_contents() end)
      if ok2 and contents then
        for _, item in pairs(contents) do give(player, item.name, item.count) end
      end
    end
  end
end

local function destroy_area(player, area)
  local surface = player.surface
  pcall(function()
    surface.cancel_deconstruct_area{ area = area, force = player.force, skip_fog_of_war = true }
  end)
  local entities = surface.find_entities_filtered{ area = area, force = player.force }
  local count = 0
  for _, entity in pairs(entities) do
    if entity.valid and entity.type ~= "character" then
      refund_items_to_place(player, entity)
      refund_inventories(player, entity)
      refund_belt_contents(player, entity)
      local ok = pcall(function() entity.destroy() end)
      if ok then count = count + 1 end
    end
  end
  player.create_local_flying_text{ text = "destroyed " .. count, position = player.position }
end

-- ================= collect (copy / move) =================

local function read_inventories(entity)
  local data = {}
  local inv_ids = { defines.inventory.chest, defines.inventory.fuel, defines.inventory.item_main }
  for _, inv_id in pairs(inv_ids) do
    local inv = nil
    pcall(function() inv = entity.get_inventory(inv_id) end)
    if inv and inv.valid then
      local ok, contents = pcall(function() return inv.get_contents() end)
      if ok and contents then
        for _, item in pairs(contents) do
          data[#data + 1] = { inv = inv_id, name = item.name, count = item.count }
        end
      end
    end
  end
  return data
end

local function collect_area(player, area, remove_originals)
  local surface = player.surface
  pcall(function()
    surface.cancel_deconstruct_area{ area = area, force = player.force, skip_fog_of_war = true }
  end)
  local entities = surface.find_entities_filtered{ area = area, force = player.force }
  local cx = (area.left_top.x + area.right_bottom.x) / 2
  local cy = (area.left_top.y + area.right_bottom.y) / 2
  local with_contents = settings.global["it-copy-contents"].value
  local list = {}
  for _, entity in pairs(entities) do
    if entity.valid and entity.type ~= "character" then
      local rec = {
        name = entity.name,
        x = entity.position.x - cx,
        y = entity.position.y - cy,
        direction = entity.direction or 0,
      }
      if with_contents then
        local inv = read_inventories(entity)
        if #inv > 0 then rec.contents = inv end
      end
      list[#list + 1] = rec
      if remove_originals then
        pcall(function() entity.destroy() end)
      end
    end
  end
  storage.copies[player.index] = list
  storage.rot[player.index] = 0
  return #list, cx, cy
end

-- ================= rotation / anchor =================

-- rotate relative position clockwise: rot is 0, 4, 8 or 12
local function rot_pos(x, y, rot)
  if rot == 4 then return -y, x
  elseif rot == 8 then return -x, -y
  elseif rot == 12 then return y, -x
  end
  return x, y
end

local function bounds(list, rot)
  local minx, maxx = math.huge, -math.huge
  local miny, maxy = math.huge, -math.huge
  for _, e in pairs(list) do
    local rx, ry = rot_pos(e.x, e.y, rot)
    if rx < minx then minx = rx end
    if rx > maxx then maxx = rx end
    if ry < miny then miny = ry end
    if ry > maxy then maxy = ry end
  end
  return minx, maxx, miny, maxy
end

-- anchor: horizontally centered on the player, bottom edge 3 tiles above the player
local function anchor(player, list, rot)
  if not list or #list == 0 then
    return { x = player.position.x, y = player.position.y - 6 }
  end
  local minx, maxx, miny, maxy = bounds(list, rot)
  local center_offset = (minx + maxx) / 2
  return {
    x = player.position.x - center_offset,
    y = player.position.y - maxy - 3,
  }
end

-- ================= ghost preview =================

local function clear_preview(player)
  storage.previews = storage.previews or {}
  local pv = storage.previews[player.index]
  if pv then
    for _, ghost in pairs(pv) do
      if ghost and ghost.valid then ghost.destroy() end
    end
  end
  storage.previews[player.index] = nil
end

local function build_preview(player)
  clear_preview(player)
  local list = storage.copies[player.index]
  if not list or #list == 0 then return end
  local rot = storage.rot[player.index] or 0
  local surface = player.surface
  local a = anchor(player, list, rot)
  local ghosts = {}
  for _, e in pairs(list) do
    local rx, ry = rot_pos(e.x, e.y, rot)
    local ok, ghost = pcall(function()
      return surface.create_entity{
        name = "entity-ghost",
        inner_name = e.name,
        position = { x = a.x + rx, y = a.y + ry },
        direction = (e.direction + rot) % 16,
        force = player.force,
        player = player,
      }
    end)
    if ok and ghost and ghost.valid then ghosts[#ghosts + 1] = ghost end
  end
  storage.previews[player.index] = ghosts
end

-- ================= place / paste =================

local function place_list(player, list, cx, cy, rot)
  local surface = player.surface
  local count = 0
  rot = rot or 0
  for _, e in pairs(list) do
    local rx, ry = rot_pos(e.x, e.y, rot)
    local ok, created = pcall(function()
      return surface.create_entity{
        name = e.name,
        position = { x = cx + rx, y = cy + ry },
        direction = (e.direction + rot) % 16,
        force = player.force,
      }
    end)
    if ok and created and created.valid then
      count = count + 1
      if e.contents then
        for _, item in pairs(e.contents) do
          local inv = nil
          pcall(function() inv = created.get_inventory(item.inv) end)
          if inv and inv.valid then
            pcall(function() inv.insert{ name = item.name, count = item.count } end)
          end
        end
      end
    end
  end
  return count
end

local function paste_at(player)
  local list = storage.copies[player.index]
  if not list or #list == 0 then
    player.create_local_flying_text{ text = "nothing to paste", position = player.position }
    return
  end
  local rot = storage.rot[player.index] or 0
  local surface = player.surface
  local a = anchor(player, list, rot)
  local cx, cy = a.x, a.y

  for _, e in pairs(list) do
    local rx, ry = rot_pos(e.x, e.y, rot)
    local ok, can = pcall(function()
      return surface.can_place_entity{
        name = e.name,
        position = { x = cx + rx, y = cy + ry },
        direction = (e.direction + rot) % 16,
        force = player.force,
      }
    end)
    if not ok or not can then
      player.create_local_flying_text{ text = "blocked: " .. e.name, position = player.position }
      clear_preview(player)
      return
    end
  end

  clear_preview(player)
  local count = place_list(player, list, cx, cy, rot)
  player.create_local_flying_text{ text = "pasted " .. count, position = player.position }
end

-- ================= planning zones =================

local plan_colors = {
  { r = 0.2, g = 0.6, b = 1.0, a = 0.22 },
  { r = 1.0, g = 0.8, b = 0.2, a = 0.22 },
  { r = 0.2, g = 1.0, b = 0.4, a = 0.22 },
  { r = 1.0, g = 0.3, b = 0.3, a = 0.22 },
  { r = 0.8, g = 0.4, b = 1.0, a = 0.22 },
}

local function add_plan(player, area)
  storage.plans = storage.plans or {}
  local idx = (storage.plan_count or 0) + 1
  storage.plan_count = idx
  local c = plan_colors[((idx - 1) % #plan_colors) + 1]
  local mid = {
    x = (area.left_top.x + area.right_bottom.x) / 2,
    y = (area.left_top.y + area.right_bottom.y) / 2,
  }
  local rect = rendering.draw_rectangle{
    color = c,
    left_top = area.left_top,
    right_bottom = area.right_bottom,
    surface = player.surface,
    filled = true,
    draw_on_ground = true,
  }
  local label = rendering.draw_text{
    text = "ZONE " .. idx,
    surface = player.surface,
    target = mid,
    color = { r = 1, g = 1, b = 1 },
    scale = 2,
    alignment = "center",
  }
  storage.plans[#storage.plans + 1] = { rect = rect.id, label = label.id }
  game.print("[InstantTools] plan zone " .. idx .. " created")
end

-- ================= events =================

local function on_area(event)
  local player = game.get_player(event.player_index)
  if not player then return end
  storage.mode = storage.mode or {}
  storage.copies = storage.copies or {}
  storage.rot = storage.rot or {}
  storage.plan_mode = storage.plan_mode or {}

  if storage.plan_mode[player.index] then
    add_plan(player, event.area)
    return
  end

  local mode = storage.mode[player.index] or "destroy"
  if mode == "copy" then
    local n = collect_area(player, event.area, false)
    player.create_local_flying_text{ text = "copied " .. n, position = player.position }
    build_preview(player)
  elseif mode == "move" then
    local n, mcx, mcy = collect_area(player, event.area, true)
    storage.undo = storage.undo or {}
    storage.undo[player.index] = { list = storage.copies[player.index], cx = mcx, cy = mcy }
    player.create_local_flying_text{ text = "moved " .. n, position = player.position }
    build_preview(player)
  else
    destroy_area(player, event.area)
  end
end

script.on_init(function()
  storage.mode = {}
  storage.copies = {}
  storage.rot = {}
  storage.previews = {}
  storage.plans = {}
end)

script.on_configuration_changed(function()
  storage.mode = storage.mode or {}
  storage.copies = storage.copies or {}
  storage.rot = storage.rot or {}
  storage.previews = storage.previews or {}
  storage.plans = storage.plans or {}
end)

script.on_event("it-toggle-mode", function(event)
  local player = game.get_player(event.player_index)
  if not player then return end
  storage.mode = storage.mode or {}
  local mode = storage.mode[player.index] or "destroy"
  if mode == "destroy" then mode = "copy"
  elseif mode == "copy" then mode = "move"
  else mode = "destroy" end
  storage.mode[player.index] = mode
  game.print("[InstantTools] mode: " .. mode)
end)

script.on_event("it-paste", function(event)
  local player = game.get_player(event.player_index)
  if not player then return end
  paste_at(player)
end)

script.on_event("it-rotate", function(event)
  local player = game.get_player(event.player_index)
  if not player then return end
  storage.rot = storage.rot or {}
  storage.rot[player.index] = ((storage.rot[player.index] or 0) + 4) % 16
  build_preview(player)
  player.create_local_flying_text{
    text = "rot " .. (storage.rot[player.index] * 90 / 4) .. " deg",
    position = player.position,
  }
end)

script.on_event("it-cancel", function(event)
  local player = game.get_player(event.player_index)
  if not player then return end
  clear_preview(player)
  storage.copies[player.index] = nil
  player.create_local_flying_text{ text = "cancelled", position = player.position }
end)

script.on_event("it-undo", function(event)
  local player = game.get_player(event.player_index)
  if not player then return end
  storage.undo = storage.undo or {}
  local u = storage.undo[player.index]
  if not u or not u.list then
    player.create_local_flying_text{ text = "nothing to undo", position = player.position }
    return
  end
  local n = place_list(player, u.list, u.cx, u.cy, 0)
  storage.undo[player.index] = nil
  clear_preview(player)
  player.create_local_flying_text{ text = "undo: " .. n .. " restored", position = player.position }
end)

script.on_event("it-plan", function(event)
  local player = game.get_player(event.player_index)
  if not player then return end
  storage.plan_mode = storage.plan_mode or {}
  storage.plan_mode[player.index] = not storage.plan_mode[player.index]
  game.print("[InstantTools] plan mode: " .. (storage.plan_mode[player.index] and "ON" or "OFF"))
end)

script.on_event("it-plan-toggle", function(event)
  local player = game.get_player(event.player_index)
  if not player then return end
  storage.plans = storage.plans or {}
  if storage.plan_visible == nil then storage.plan_visible = true end
  storage.plan_visible = not storage.plan_visible
  for _, p in pairs(storage.plans) do
    local r = rendering.get(p.rect)
    local l = rendering.get(p.label)
    if r and r.valid then r.visible = storage.plan_visible end
    if l and l.valid then l.visible = storage.plan_visible end
  end
  game.print("[InstantTools] plan overlay: " .. (storage.plan_visible and "shown" or "hidden"))
end)

script.on_event(defines.events.on_player_changed_position, function(event)
  local player = game.get_player(event.player_index)
  if not player then return end
  storage.previews = storage.previews or {}
  if storage.previews[player.index] then
    build_preview(player)
  end
end)

script.on_event(defines.events.on_player_deconstructed_area, on_area)
script.on_event(defines.events.on_player_selected_area, on_area)
