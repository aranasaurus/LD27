Actor = {
  x = 0,
  y = 0,
  w = 16,
  h = 60,
  dw = 0,
  xVel = 0,
  yVel = 0,
  maxVel = 6,
  rotation = 0,
  rx = 0,
  ry = 0,
  vx = 0,
  vy = 0,
  body = {},
  weapon = {},
  color = {}
}

function Actor:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self

  o.dw = math.max(o.w, o.h)
  o.body = { -o.w/2,-o.h/2, o.w/2,-o.h/2, o.w/2,o.h/2, -o.w/2,o.h/2 }
  o.weapon = { o.w/2+2,-10, o.w/2+5,0, o.w/2+2,10 }
  return o
end

function Actor:draw()
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

function Actor:update(dt)
  self.rotation = math.atan2(self.ry, self.rx)
  self.xVel = self.vx*self.maxVel
  self.yVel = self.vy*self.maxVel

  self.x = self.x + self.xVel
  self.y = self.y + self.yVel
end

function Actor:faceUp()
  self.rotation = -90*math.pi/180
end

function Actor:faceDown()
  self.rotation = 90*math.pi/180
end

function Actor:faceRight()
  self.rotation = 0
end

function Actor:faceLeft()
  self.rotation = math.pi
end

function Actor:facePoint(p)
  self.rx = p[1] - (self.x + self.w/2)
  self.ry = p[2] - (self.y + self.h/2)
end

function Actor:hitBox()
  local pw = self.dw/2
  return {
    left=self.x-pw,
    top=self.y-pw,
    right=self.x+pw,
    bottom=self.y+pw
  }
end
