require("player")
require("level")
PADDING = 16
PATH_WIDTH = 66

function love.load()
  level:init(love.graphics.getWidth() - PADDING*2, love.graphics.getHeight() - PADDING*2)
  player:init(level.player_start.x, level.player_start.y)

  -- Uncomment to disable joystick TODO: Make this a config option
  --love.joystick.close(1)
end

function love.draw()
  love.graphics.translate(PADDING, PADDING)

  level:draw()
  player:draw()
end

function love.update(dt)
  player:update(dt)
  level:update(dt)
end

function love.joystickpressed(joystick, button)
  print("player x: "..player.x..", y: "..player.y)
end

