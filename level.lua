require("patrol")
level = {}

function level:init(w, h)
  self.w = w
  self.h = h
  self.floorColor = {144, 144, 144, 255}
  self.wallColor = {64, 64, 64, 255}
  self.wallThickness = 8
  self.perimeter = { 0,0, self.w,0, self.w,self.h, 0,self.h }
  self.walls = {
    {
      lines = {
        t = {100,100, 250,100},
        r = {250,100, 250,650},
        b = {100,650, 250,650},
        l = {100,100, 100,650}
      }
    }
  }
  self.player_start = { x=28, y=35 }
  local p = Patrol:new()
  p:init(300,400, {{m={300, 100+p.w/2}, l={300,-10000}}, {m={300, 650-p.w/2}, l={300,10000}}}, 1)
  self.patrols = { p }
end

function level:draw()
  -- Floor
  love.graphics.setColor(self.floorColor)
  love.graphics.rectangle("fill", 0, 0, self.w, self.h)

  -- Walls
  love.graphics.setColor(self.wallColor)
  love.graphics.setLineWidth(self.wallThickness)
  love.graphics.setLineStyle("rough")
  love.graphics.polygon("line", self.perimeter)
  for _, wall in ipairs(self.walls) do
    local lines = wall.lines
    love.graphics.polygon("fill", {
      lines.t[1], lines.t[2],
      lines.r[1], lines.r[2],
      lines.b[3], lines.b[4],
      lines.l[3], lines.l[4]
    })
  end

  for _, p in ipairs(self.patrols) do
    p:draw()
  end
end

function level:update(dt)
  self:checkPerimeter(player)
  self:checkWalls(player)

  for _, p in ipairs(self.patrols) do
    p:update(dt)
    self:checkPerimeter(p)
    self:checkWalls(p)
  end
end

function level:checkPerimeter(a)
  -- TODO: I think this can be done more better using level.perimeter
  local pw = a.dw/2
  a.x = math.max(a.x, pw+self.wallThickness/2)
  a.x = math.min(a.x, self.w-self.wallThickness/2-pw)
  a.y = math.max(a.y, pw+self.wallThickness/2)
  a.y = math.min(a.y, self.h-self.wallThickness/2-pw)
end

function level:checkWalls(a)
  local pb = player:hitBox()
  local function checkX(line)
    return (pb.left > line[1] and pb.left < line[#line-1]) or (pb.right > line[1] and pb.right < line[#line-1])
  end
  local function checkY(line)
    return (pb.bottom > line[2] and pb.bottom < line[#line]) or (pb.top > line[2] and pb.top < line[#line])
  end
  for _, w in ipairs(self.walls) do
    for facing, line in pairs(w.lines) do
      if facing == 't' then
        if checkX(line) then
          local wy = line[2]
          local dy = pb.bottom - wy
          if dy > 0 and dy < a.maxVel*2 then
            -- Collision!
            a.y = wy - a.dw/2
          end
        end
      elseif facing == 'r' then
        if checkY(line) then
          local wx = line[1]
          local dx = wx - pb.left
          if dx > 0 and dx < a.maxVel*2 then
            -- Collision!
            a.x = wx + a.dw/2
          end
        end
      elseif facing == 'b' then
        if checkX(line) then
          local wy = line[2]
          local dy = wy - pb.top
          if dy > 0 and dy < a.maxVel*2 then
            -- Collision!
            a.y = wy + a.dw/2
          end
        end
      elseif facing == 'l' then
        if checkY(line) then
          local wx = line[1]
          local dx = pb.right - wx
          if dx > 0 and dx < a.maxVel*2 then
            -- Collision!
            a.x = wx - a.dw/2
          end
        end
      end
    end
  end
end

