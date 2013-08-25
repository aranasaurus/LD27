require("actor")
Patrol = Actor:new({ color = {66, 0, 0} })

function Patrol:init(x, y, targets, stopDuration)
  self.x = x
  self.y = y
  self.reachedTargetAt = -1
  self.stopDuration = stopDuration
  self.currentDir = {-1, -1}
  self.targets = {}
  self.lookTargets = {}
  for _, t in ipairs(targets) do
    table.insert(self.targets, t.m)
    table.insert(self.lookTargets, t.l)
  end
  self:setTarget(1)
end

function Patrol:setTarget(ti)
  local t = self.targets[ti]
  self.currentTargetIndex = ti
  self.currentTarget = t
  if self.x < t[1] then
    self.currentDir[1] = 1
  elseif self.x > t[1] then
    self.currentDir[1] = -1
  else
    self.currentDir[1] = 0
  end

  if self.y < t[2] then
    self.currentDir[2] = 1
  elseif self.y > t[2] then
    self.currentDir[2] = -1
  else
    self.currentDir[2] = 0
  end
end

function Patrol:checkTimer()
  if love.timer.getTime() - self.reachedTargetAt > self.stopDuration then
    local nextIndex = self.currentTargetIndex % #self.targets + 1
    self:setTarget(nextIndex)
    self.reachedTargetAt = -1
  end
end

function Patrol:updateTarget()
  if self.currentDir[2] < 0 then
    -- traveling up
    if self.reachedTargetAt > 0 then
      -- already at target, check timer and change target if enough time has passed
      self:checkTimer()
    else
      -- check if we've reached the target, else progress toward it
      if self.y < self.currentTarget[2] then
        -- reached target height from below
        self.y = self.currentTarget[2]
        self.vy = 0
        if self.x == self.currentTarget[1] then
          -- reached target, save current time
          self.reachedTargetAt = love.timer.getTime()
        end
      else
        -- not at target yet, keep moving upward
        self.vy = -1
      end
    end
  elseif self.currentDir[2] > 0 then
    -- traveling down
    if self.reachedTargetAt > 0 then
      -- already at target, check timer and change target if enough time has passed
      self:checkTimer()
    else
      -- check if we've reached the target, else progress toward it
      if self.y > self.currentTarget[2] then
        -- reached target height from above
        self.y = self.currentTarget[2]
        self.vy = 0
        if self.x == self.currentTarget[1] then
          -- reached target, save current time
          self.reachedTargetAt = love.timer.getTime()
        end
      else
        -- not at target yet, keep moving upward
        self.vy = 1
      end
    end
  end
end

function Patrol:update(dt)
  self:updateTarget()
  self:facePoint(self.lookTargets[self.currentTargetIndex])
  Actor.update(self, dt)
end

function Patrol:draw()
  Actor.draw(self)

  if false then
    love.graphics.push()
    love.graphics.setColor(255, 255, 255)
    love.graphics.point(self.currentTarget[1], self.currentTarget[2])
    love.graphics.pop()
  end
end
