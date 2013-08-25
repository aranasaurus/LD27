player = {}

function player:init(x, y)
  self.x = x
  self.y = y
  self.w = 16
  self.h = 60
  self.dw = math.max(self.w, self.h)
  self.xVel = 0
  self.yVel = 0
  self.maxVel = 6
  self.rotation = 0
  self.rx = 0
  self.ry = 0
  self.vx = 0
  self.vy = 0
  self.body = { -self.w/2,-self.h/2, self.w/2,-self.h/2, self.w/2,self.h/2, -self.w/2,self.h/2 }
  self.weapon = { self.w/2+2,-10, self.w/2+5,0, self.w/2+2,10 }
  self.color = { 33, 33, 200 }
end

function player:draw()
  love.graphics.push()
  love.graphics.translate(self.x, self.y)
  love.graphics.rotate(self.rotation)

  love.graphics.setColor(self.color)
  love.graphics.polygon("fill", self.body)
  love.graphics.setColor(255, 0, 0)
  love.graphics.setLineStyle("smooth")
  love.graphics.setLineWidth(2)
  love.graphics.line(self.weapon)
  love.graphics.pop()
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

  self.rotation = math.atan2(self.ry, self.rx)
  self.xVel = self.vx*self.maxVel
  self.yVel = self.vy*self.maxVel

  self.x = self.x + self.xVel
  self.y = self.y + self.yVel

end

function player:hitBox()
  local pw = self.dw/2
  return {
    left=self.x-pw,
    top=self.y-pw,
    right=self.x+pw,
    bottom=self.y+pw
  }
end
