require("player")
PADDING = 16
PATH_WIDTH = 66
game = {
  level = {
    floorColor = {144, 144, 144, 255},
    wallColor = {64, 64, 64, 255},
    wallThickness = 14,
    player_start = { x=2, y=2 }
  }
}

function love.load()
  game.level.size = { w = love.graphics.getWidth() - PADDING*2, h = love.graphics.getHeight() - PADDING*2 }
  player:init(game.level.player_start.x, game.level.player_start.y)
  -- Uncomment to disable joystick TODO: Make this a config option
  --love.joystick.close(1)
end

function love.draw()
  love.graphics.push()

  love.graphics.translate(PADDING, PADDING)
  -- Floor
  love.graphics.setColor(game.level.floorColor)
  love.graphics.rectangle("fill", 0, 0, game.level.size.w, game.level.size.h)

  -- Walls
  -- outer
  love.graphics.setColor(game.level.wallColor)
  love.graphics.setLineWidth(game.level.wallThickness)
  love.graphics.rectangle("line", 0, 0, game.level.size.w, game.level.size.h)

  -- inner
  love.graphics.translate(game.level.wallThickness, game.level.wallThickness)
  local wall = {
    x = PATH_WIDTH*1.5,
    y = PATH_WIDTH,
    w = 150
  }
  wall.h = game.level.size.h - wall.y - PATH_WIDTH - game.level.wallThickness
  love.graphics.rectangle("fill", wall.x, wall.y, wall.w, wall.h)


  love.graphics.pop()
  player:draw()
end

function love.update(dt)
  player:update(dt)
  player.x = math.max(0, player.x)
  player.x = math.min(player.x, love.graphics.getWidth()-player.w)
end

