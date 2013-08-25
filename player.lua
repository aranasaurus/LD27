require("actor")
player = Actor:new({ color = {0, 105, 15} })

function player:init(x, y)
  self.x = x
  self.y = y
end

function player:update(dt)
  if love.joystick.isOpen(1) then
    local j = love.joystick
    self.vx = j.getAxis(1, 1)
    self.vy = j.getAxis(1, 2)
    local jx = j.getAxis(1, 3)
    local jy = j.getAxis(1, 4)

    local deadzone = 0.20
    if math.abs(jx) > deadzone or math.abs(jy) > deadzone then
      self.rx = jx
      self.ry = jy
    end
    if math.abs(self.vx) < deadzone then
      self.vx = 0
    end
    if math.abs(self.vy) < deadzone then
      self.vy = 0
    end
  else -- use the keyboard and mouse
    -- rotate so that we are always facing the mouse pointer
    local mx, my = love.mouse.getPosition()
    self.rx = mx - (self.x+self.w/2)
    self.ry = my - (self.y+self.h/2)

    local kb = love.keyboard
    if kb.isDown("d") then
      self.vx = 1
    elseif kb.isDown("a") then
      self.vx = -1
    else
      self.vx = 0
    end

    if kb.isDown("w") then
      self.vy = -1
    elseif kb.isDown("s") then
      self.vy = 1
    else
      self.vy = 0
    end
  end

  Actor.update(self, dt)
end

